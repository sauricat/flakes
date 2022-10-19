;;; shu-tex --- LaTeX configuration of Shu
;;; Commentary:
"LaTeX configuration combined with EMACS of Shu"
;;; Code:

(setq tex-default-mode 'latex-mode
      latex-run-command "xelatex"
      tex-run-command "xelatex"
      tex-print-file-extension ".pdf"
      tex-dvi-view-command "emacsclient -e \"(find-file-other-window \\\"*\\\")\"")

(use-package obsidian
  :config
  (obsidian-specify-path "~/Documents/Obsidian")
  (global-obsidian-mode t)
  :custom
  ;; This directory will be used for `obsidian-capture' if set.
  (obsidian-inbox-directory "Inbox")
  :bind (:map obsidian-mode-map
  ;; Replace C-c C-o with Obsidian.el's implementation. It's ok to use another key binding.
  ("C-c C-o" . obsidian-follow-link-at-point)
  ;; Jump to backlinks
  ("C-c C-b" . obsidian-backlink-jump)
  ;; If you prefer you can use `obsidian-insert-link'
  ("C-c C-l" . obsidian-insert-wikilink)))

(provide 'shu-tex)
;;; shu-tex.el ends here
