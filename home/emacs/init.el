(global-set-key (kbd "C-z") 'undo)
(setq inhibit-splash-screen t)
(xterm-mouse-mode t)

(tool-bar-mode 0)
(menu-bar-mode t)
(scroll-bar-mode 0) 

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))


(use-package winum
  :ensure
  :config
  (winum-mode))

(use-package ivy
  :ensure t
  :config
  (ivy-mode))

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-tomorrow-day t))

(use-package multi-vterm
  :ensure t
  :config
  (bind-keys :map global-map
	     :prefix-map my-prefix-map
             :prefix "C-t"
	     ("c" . multi-vterm) ;; c means create
	     ("p" . multi-vterm-prev)	    
	     ("n" . multi-vterm-next)))


