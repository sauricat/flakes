;;; shu-c --- C and C++ modes
;;; Commentary:
"C and C++ modes"
;;; Code:
(use-package cmake-mode)

(setq-default c-basic-offset 4
	      c-default-style '((java-mode . "java")
				(awk-mode . "awk")
				(other . "linux")))

(provide 'shu-c)
;;; shu-c.el ends here
