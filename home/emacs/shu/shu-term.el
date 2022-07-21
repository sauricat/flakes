;;; shu-term --- terminal configuration
;;; Commentary:
"Use terminal emulator in emacs."
;;; Code:

(use-package vterm
  ;; :hook
  ;; (vterm-mode . (vterm--toggle-mouse t))
  ;; :config
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
  (rename-buffer (format "*%s@%s*"
                         (process-name vterm--process)
                         (vterm--get-pwd))))
(defun shu-vterm-auto-rename ()
  "Rename vterm buffer with current directory info."
  (interactive)
  (sit-for 0.1) ;; I don't know why it works. Or Emacs crashes.
  (rename-buffer (format "*%s@%s*"
                         (process-name vterm--process)
                         (vterm--get-pwd))))

(define-key vterm-mode-map [return] 'shu-vterm-auto-rename-send-return)
(defvar multi-vterm-buffer-name "vterm")
(add-hook 'vterm-mode-hook 'shu-vterm-auto-rename)

(provide 'shu-term)
;;; shu-term.el ends here.
