;;; shu-tex --- LaTeX configuration of Shu
;;; Commentary:
"LaTeX configuration combined with EMACS of Shu"
;;; Code:

(setq tex-default-mode 'latex-mode
      latex-run-command "xelatex"
      tex-run-command "xelatex"
      tex-print-file-extension ".pdf"
      tex-dvi-view-command "emacsclient -e \"(find-file-other-window \\\"*\\\")\"")
(provide 'shu-tex)
;;; shu-tex.el ends here
