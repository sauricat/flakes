;;; init --- Init file of emacs
;;; Commentary:

;;; Code:
(global-set-key (kbd "C-z") 'undo)
(global-unset-key (kbd "C-x C-z"))
(global-set-key (kbd "C-M-z") 'linum-mode)
(global-set-key (kbd "C-M-/") 'comment-or-uncomment-region)
(global-set-key (kbd "C-<tab>") 'find-file-at-point)
(setq inhibit-splash-screen t) ;; hide welcome screen
(xterm-mouse-mode t) ;; use mouse in -nw mode
(tool-bar-mode 0) (menu-bar-mode 0) (scroll-bar-mode 0)
(pixel-scroll-precision-mode t) ;; smooth scrolling
(defalias 'yes-or-no-p 'y-or-n-p)
(desktop-save-mode 1) ;; auto save window
(setq mouse-drag-copy-region 1)

(package-initialize)

(setq use-package-always-ensure t)

(use-package diminish
  :config
  (diminish 'eldoc-mode)) ;; other configs are in use-package :diminish

(use-package magit
  :bind (("C-x g g" . magit-status)
	 ("C-x g b" . magit-blame)
	 ("C-x g d" . magit-diff-buffer-file)))

;; Window Management
(use-package winum
  :config (winum-mode))

;; EXWM
(use-package exwm
  :config
  (require 'exwm-config)
  (defun exwm-rename-buffer () ;; show app name in every exwm buffer
    (interactive)
    (exwm-workspace-rename-buffer
     (concat exwm-class-name ":"
             (if (<= (length exwm-title) 50) exwm-title
               (concat (substring exwm-title 0 49) "...")))))
  (add-hook 'exwm-update-class-hook 'exwm-rename-buffer)
  (add-hook 'exwm-update-title-hook 'exwm-rename-buffer)
  
  (fringe-mode '(10 . 10))

  (setq exwm-workspace-number 4)

  ;; this is a way to declare truly global/always working keybindings
  ;; this is a nifty way to go back from char mode to line mode without using the mouse
  (exwm-input-set-key (kbd "s-r") #'exwm-reset)
  (exwm-input-set-key (kbd "s-k") #'exwm-workspace-delete)
  (exwm-input-set-key (kbd "s-w") #'exwm-workspace-swap)

  ;; the next loop will bind s-<number> to switch to the corresponding workspace
  (dotimes (i 10)
    (exwm-input-set-key (kbd (format "s-%d" i))
                        `(lambda ()
                           (interactive)
                           (exwm-workspace-switch-create ,(- i 1)))))
  
  ;; the simplest launcher, I keep it in only if dmenu eventually stopped working or something
  (exwm-input-set-key (kbd "<VoidSymbol>") ;; caps:none
                      (lambda (command)
                        (interactive (list (read-shell-command "$ ")))
                        (start-process-shell-command command nil command)))

  ;; an easy way to make keybindings work *only* in line mode
  (push ?\C-q exwm-input-prefix-keys)
  (define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

  ;; simulation keys are keys that exwm will send to the exwm buffer upon inputting a key combination
  (exwm-input-set-simulation-keys
   '(([?\C-w] . ?\C-x)
     ([?\M-w] . ?\C-c)
     ([?\C-y] . ?\C-v)
     ([?\C-x ?h] . ?\C-a)
     ;; search
     ([?\C-s] . ?\C-f)
     ([?\C-x ?\C-s] . ?\C-s)
     ;; deleted all movement
     ;; ([?\C-b] . left)
     ;; ([?\M-b] . C-left)
     ;; ([?\C-f] . right)
     ;; ([?\M-f] . C-right)
     ;; ([?\C-p] . up)
     ;; ([?\C-n] . down)
     ;; ([?\C-a] . home)
     ;; ([?\C-e] . end)
     ;; ([?\M-v] . prior)
     ;; ([?\C-v] . next)
     ;; ([?\C-d] . delete)
     ;; ([?\C-k] . (S-end delete))
     ))

  ;; this little bit will make sure that XF86 keys work in exwm buffers as well
  (dolist (k '(XF86AudioLowerVolume
               XF86AudioRaiseVolume
               XF86PowerOff
               XF86AudioMute
               XF86AudioPlay
               XF86AudioStop
               XF86AudioPrev
               XF86AudioNext
               XF86ScreenSaver
               XF86Back
               XF86Forward
               Scroll_Lock
               print))
    (cl-pushnew k exwm-input-prefix-keys)))
(add-hook 'after-make-frame-functions
	  (lambda (frame)
	    (select-frame frame)
	    (find-file-read-only "~/.background-image" nil)))

;; Ivy tool set
(use-package ivy
  :diminish ivy-mode
  :config
  (ivy-mode)
  (define-key global-map (kbd "C-x b") 'ivy-switch-buffer)
  (define-key global-map (kbd "C-c v") 'ivy-push-view)
  (define-key global-map (kbd "C-c V") 'ivy-pop-view))
(use-package counsel
  :config
  (define-key global-map (kbd "M-x") 'counsel-M-x)
  (define-key global-map (kbd "C-x C-f") 'counsel-find-file)
  (define-key global-map (kbd "M-y") 'counsel-yank-pop)
  (define-key global-map (kbd "<f1> f") 'counsel-describe-function)
  (define-key global-map (kbd "<f1> v") 'counsel-describe-variable)
  (define-key global-map (kbd "<f1> l") 'counsel-find-library)
  (define-key global-map (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (define-key global-map (kbd "<f2> u") 'counsel-unicode-char)
  (define-key global-map (kbd "<f2> j") 'counsel-set-variable))
(use-package swiper
  :config (define-key global-map (kbd "C-s") 'swiper-isearch))

;; Zoxide find file
(use-package zoxide
  :hook ((find-file
	  counsel-find-file) . zoxide-add))
(use-package fzf
  :bind (("C-c C-f" . fzf-directory)
	 ("C-c g" . fzf-git-grep) ;; C-c C-g is improper since C-g is Quit
	 ))

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
        company-tooltip-limit 10
        company-show-numbers t
        company-idle-delay 1
        company-minimum-prefix-length 3))

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
	 ("s-<return>" . multi-vterm)
	 ("C-c t p" . multi-vterm-prev)
	 ("C-c t n" . multi-vterm-next)))

;; Parentheses and highlight TODO
(show-paren-mode t)
(setq show-paren-style 'parenthesis)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(("TODO"       warning bold)
          ("FIXME"      error bold)
          ("HACK"       font-lock-constant-face bold)
          ("REVIEW"     font-lock-keyword-face bold)
          ("NOTE"       success bold)
          ("DEPRECATED" font-lock-doc-face bold)
          ("DEBUG"      error bold))))

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
(use-package dirvish
  :config (dirvish-override-dired-mode))

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

;; Undo tree
(use-package undo-tree
  :delight
  :diminish undo-tree-mode
  :config
  (setq undo-tree-visualizer-timestamps t
        undo-tree-visualizer-diff t
        undo-tree-auto-save-history nil
        ;; undo-tree-history-directory-alist `(("." . ,(expand-file-name ".cache/undo-tree/" user-emacs-directory)))
        )
  (global-undo-tree-mode))

;; Language server
;; (use-package lsp-mode
;;   :commands (lsp)
;;   :hook (((ruby-mode
;; 	   nix-mode
;; 	   rust-mode) . lsp))
;;   :init
;;   (setq lsp-auto-configure t
;;         lsp-auto-guess-root t
;;         lsp-idle-delay 0.500
;;         lsp-session-file "~/.emacs/.cache/lsp-sessions"))
;; (use-package lsp-ivy
;;   :diminish
;;   :after lsp-mode)
;; (use-package lsp-ui
;;   :after (lsp-mode)
;;   :diminish
;;   :commands (lsp-ui-mode)
;;   :bind
;;   (:map lsp-ui-mode-map
;;         ("M-?" . lsp-ui-peek-find-references)
;;         ("M-." . lsp-ui-peek-find-definitions)
;;         ("C-c u" . lsp-ui-imenu))
;;   :hook (lsp-mode . lsp-ui-mode)
;;   :init
;;   ;; https://github.com/emacs-lsp/lsp-mode/blob/master/docs/tutorials/how-to-turn-off.md
;;   (setq lsp-enable-symbol-highlighting t
;;         lsp-ui-doc-enable t
;;         lsp-lens-enable t))

;; Lsp-bridge
(use-package posframe)
(use-package markdown-mode)
(use-package yasnippet)
(add-to-list 'load-path "~/.emacs.d/lsp-bridge")
(require 'lsp-bridge)
(yas-global-mode 1)
(global-lsp-bridge-mode)

;; Matrix Client
(use-package ement)

(provide 'init)
;;; init.el ends here
