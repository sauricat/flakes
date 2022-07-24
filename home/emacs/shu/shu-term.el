;;; shu-term --- terminal configuration
;;; Commentary:
"Use terminal emulator in emacs."
;;; Code:

(use-package vterm
  ;; :hook
  ;; (vterm-mode . (vterm--toggle-mouse t))
  :config
  (setq vterm-shell "/run/current-system/sw/bin/fish")
  ;; (setq vterm-shell "tmux new-session -t main")
  ;; (define-key vterm-mode-map (kbd "<wheel-up>") [mouse-4])
  ;; (define-key vterm-mode-map (kbd "<wheel-down>") [mouse-5])
  )

(use-package multi-vterm
  :bind (("C-c t c" . multi-vterm) ;; c means create
         ("C-c t p" . multi-vterm-prev)
         ("C-c t n" . multi-vterm-next)))

(defun shu-vterm-auto-rename-send-return ()
  "Rename vterm buffer with current directory info, send return."
  (interactive)
  (vterm-send-return)
  (sit-for 0.5)
  (unless (eq multi-vterm-dedicated-buffer (current-buffer))
     (rename-buffer (format "*%s@%s*"
                            (process-name vterm--process)
                            (replace-regexp-in-string
                             "\\(.*\\)/" "\\1"
                             (replace-regexp-in-string
                              ".*/\\([^/]*/[^/]*/[^/]*\\)/" ".../\\1/"
                              (vterm--get-pwd)))))))

(define-key vterm-mode-map [return] 'shu-vterm-auto-rename-send-return)
(setq multi-vterm-buffer-name "vterm")
;; (add-hook 'vterm-mode-hook 'shu-vterm-auto-rename)

(provide 'shu-term)
;;; shu-term.el ends here.
