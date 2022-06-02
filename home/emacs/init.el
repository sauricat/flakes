;;; init --- Init file of emacs
;;; Commentary:

;;; Code:
(global-set-key (kbd "C-z") 'undo)
(global-unset-key (kbd "C-x C-z"))
(global-set-key (kbd "C-M-z") 'linum-mode)
(global-set-key (kbd "C-<tab>") 'find-file-at-point)
(setq inhibit-splash-screen t) ; hide welcome screen
(xterm-mouse-mode t) ; use mouse in -nw mode

(tool-bar-mode 0)
(menu-bar-mode t)
(scroll-bar-mode 0)

(setq use-package-always-ensure t)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package winum
  :config (winum-mode))

(use-package ivy
  :config
  (ivy-mode)
  (global-set-key (kbd "C-x b") 'ivy-switch-buffer)
  (global-set-key (kbd "C-c v") 'ivy-push-view)
  (global-set-key (kbd "C-c V") 'ivy-pop-view))

(use-package counsel
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "M-y") 'counsel-yank-pop)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "<f2> j") 'counsel-set-variable))

(use-package swiper
  :config (global-set-key (kbd "C-s") 'swiper-isearch))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-tomorrow-day t))

(use-package vterm)
(use-package multi-vterm
  :config (bind-keys
	   :map global-map
	   :prefix-map my-prefix-map
           :prefix "C-t"
	   ("c" . multi-vterm) ;; c means create
	   ("p" . multi-vterm-prev)
	   ("n" . multi-vterm-next)))

(use-package paredit
  :hook ((emacs-lisp-mode . enable-paredit-mode)
	 (eval-expression-minibuffer-setup . enable-paredit-mode)
         (ielm-mode . enable-paredit-mode)
         (lisp-mode . enable-paredit-mode)
	 (lisp-interaction-mode . enable-paredit-mode)
	 (racket-mode . enable-paredit-mode)))

(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle))

(use-package racket-mode
  :mode ("\\.rkt\\'" . racket-mode)
  :hook (racket-mode . racket-xp-mode))
(use-package nix-mode)
(use-package markdown-mode)
(use-package yaml-mode)
(use-package fish-mode)

(use-package dired-single
  :config
  (defun my-dired-init ()
    "Bunch of stuff to run for dired, either immediately or when it's
   loaded."
    ;; <add other stuff here>
    (define-key dired-mode-map [remap dired-find-file]
      'dired-single-buffer)
    (define-key dired-mode-map [remap dired-mouse-find-file-other-window]
      'dired-single-buffer-mouse)
    (define-key dired-mode-map [remap dired-up-directory]
      'dired-single-up-directory))

  ;; if dired's already loaded, then the keymap will be bound
  (if (boundp 'dired-mode-map)
      ;; we're good to go; just add our bindings
      (my-dired-init)
    ;; it's not loaded yet, so add our bindings to the load-hook
    (add-hook 'dired-load-hook 'my-dired-init)))

(use-package pdf-tools
  :config
  (pdf-tools-install)
  ;; Pdf and swiper does not work together
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward-regexp))

(use-package highlight-parentheses
  :config
  (global-highlight-parentheses-mode))

(use-package flycheck
  :config (global-flycheck-mode))

(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-tooltip-align-annotations t
        company-tooltip-limit 20
        company-show-numbers t
        company-idle-delay .2
        company-minimum-prefix-length 1))

(use-package tree-sitter ; to live on the tree “Shēnghuó zài shù shàng.”
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-mode-hook 'tree-sitter-hl-mode))
(use-package tree-sitter-langs
  :config
  (add-to-list 'tree-sitter-major-mode-language-alist '(markdown-mode . markdown)))

(provide 'init)
;;; init.el ends here
