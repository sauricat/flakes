;;; init --- Init file of emacs
;;; Commentary:

;;; Code:
(global-set-key (kbd "C-z") 'undo)
(global-unset-key (kbd "C-x C-z"))
(global-set-key (kbd "C-M-z") 'linum-mode)
(global-set-key (kbd "C-M-/") 'comment-or-uncomment-region)
(global-set-key (kbd "C-<tab>") 'find-file-at-point)
(setq inhibit-splash-screen t) ; hide welcome screen
(xterm-mouse-mode t) ; use mouse in -nw mode
(tool-bar-mode 0) (menu-bar-mode t) (scroll-bar-mode 0) ; hide toolbar and scrollbar

(package-initialize)

(setq use-package-always-ensure t)

(use-package diminish
  :config
  (diminish 'eldoc-mode)) ;; other configs are in use-package :diminish

(use-package magit
  :bind (("C-x g g" . magit-status)
	 ("C-x g b" . magit-blame)
	 ("C-x g d" . magit-diff-buffer-file)))

(use-package winum
  :config (winum-mode))

;; Ivy tool set
(use-package ivy
  :diminish ivy-mode
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

;; Zoxide
(use-package zoxide
  :hook ((find-file
	  counsel-find-file) . zoxide-add))
(use-package fzf
  :bind (("C-c C-f" . fzf-find-file)
	 ("C-c C-g" . fzf-grep)
	 ("C-c C-d" . fzf-find-file-in-dir)))

;; Regex replace
(use-package anzu
  :bind ("C-r" . anzu-query-replace-regexp))

;; Spell check and auto fill
(use-package flycheck
  :config (global-flycheck-mode))
(use-package company
  :diminish company-mode
  :hook (after-init . global-company-mode)
  :config
  (setq company-tooltip-align-annotations t
        company-tooltip-limit 20
        company-show-numbers t
        company-idle-delay .2
        company-minimum-prefix-length 1))

;; Theme
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)

  ;; FIXME: These below are now global. We should patch doom
  ;;        themes to let them display correctly in terminal.
  (defun new-frame-setup (frame)
    (if (display-graphic-p frame)
	(load-theme 'doom-tomorrow-day t)
      (disable-theme 'doom-tomorrow-day)))
  (mapc 'new-frame-setup (frame-list))
  (add-hook 'after-make-frame-functions 'new-frame-setup))

;; Terminal
(use-package vterm)
(use-package multi-vterm
  :bind (("C-c t c" . multi-vterm) ;; c means create
	 ("C-t" . multi-vterm-prev) ;; most often used
	 ("C-c t p" . multi-vterm-prev)
	 ("C-c t n" . multi-vterm-next)))

;; Parenthesis
(use-package highlight-parentheses
  :diminish highlight-parentheses-mode
  :config (global-highlight-parentheses-mode))
(use-package paredit ;; strict
  :diminish (paredit-mode . " Par:S")
  :hook ((emacs-lisp-mode
	  eval-expression-minibuffer-setup
	  ielm-mode
	  lisp-mode
	  lisp-interaction-mode
	  racket-mode) . enable-paredit-mode))
;; (use-package smartparens
;;   :diminish
;;   (smartparens-mode . " Par:F")
;;   :hook
;;   ((nix-mode
;;     rust-mode
;;     ruby-mode). smartparens-mode))

;; Language modes
(use-package racket-mode
  :mode ("\\.rkt\\'" . racket-mode)
  :hook (racket-mode . racket-xp-mode))
(use-package nix-mode)
(use-package markdown-mode)
(use-package yaml-mode)
(use-package fish-mode)
(use-package rust-mode)
(use-package cargo)

;; Dired
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
(use-package neotree ;; TODO: replace it w/ dired plugins
  :config (global-set-key [f8] 'neotree-toggle))

;; PDF
(use-package pdf-tools
  :config
  (pdf-tools-install)
  ;; Pdf and swiper does not work together
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward-regexp))

;; To live on the tree “Shēnghuó zài shù shàng”
(use-package tree-sitter
  :hook (tree-sitter-mode . tree-sitter-hl-mode)
  :config (global-tree-sitter-mode)
  (diminish 'tree-sitter-mode " 🌲"))
(use-package tree-sitter-langs
  :config
  (add-to-list 'tree-sitter-major-mode-language-alist '(markdown-mode . markdown)))

;; Language server
(use-package lsp-mode
  :commands (lsp)
  :hook (((ruby-mode
	   nix-mode
	   rust-mode) . lsp))
  :init
  (setq lsp-auto-configure t
        lsp-auto-guess-root t
        lsp-idle-delay 0.500
        lsp-session-file "~/.emacs/.cache/lsp-sessions"))
(use-package lsp-ivy
  :diminish
  :after lsp-mode)
(use-package lsp-ui
  :after (lsp-mode)
  :diminish
  :commands (lsp-ui-mode)
  :bind
  (:map lsp-ui-mode-map
        ("M-?" . lsp-ui-peek-find-references)
        ("M-." . lsp-ui-peek-find-definitions)
        ("C-c u" . lsp-ui-imenu))
  :hook (lsp-mode . lsp-ui-mode)
  :init
  ;; https://github.com/emacs-lsp/lsp-mode/blob/master/docs/tutorials/how-to-turn-off.md
  (setq lsp-enable-symbol-highlighting t
        lsp-ui-doc-enable t
        lsp-lens-enable t))

(provide 'init)
;;; init.el ends here
