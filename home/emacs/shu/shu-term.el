;;; shu-term --- terminal configuration
;;; Commentary:
"Use terminal emulator in emacs."
;;; Code:

(use-package vterm
  ;; :hook
  ;; (vterm-mode . (vterm--toggle-mouse t))
  ;; :bind ("C-c t t" . vterm)
  ;; :config
  ;; (setq vterm-shell "tmux new-session -t main")
  ;; (define-key vterm-mode-map (kbd "<wheel-up>") [mouse-4])
  ;; (define-key vterm-mode-map (kbd "<wheel-down>") [mouse-5])
  )

(use-package multi-vterm
  :bind (("C-c t c" . multi-vterm) ;; c means create
         ("C-c t p" . multi-vterm-prev)
         ("C-c t n" . multi-vterm-next)))

(provide 'shu-term)
;;; shu-term.el ends here.
