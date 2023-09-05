;;; shu-exwm --- Configuration of Emacs X Window Manager
;;; Commentary:
"Configuration of exwm."
;;; Code:

(defun shu-exwm-start-process-gui-command (cmd)
  "A temporary solution when `start-process-shell-command' doesn't work for X apps (marked as CMD)."
  (progn (multi-vterm-dedicated-open) ;; temporary solution
         (message cmd)
         (vterm-send-string (format "%s & \n" cmd))
         (multi-vterm-dedicated-close)))

(defun shu-exwm-lock-screen ()
  "Lock screen."
  (interactive)
  (shu-exwm-start-process-gui-command "i3lock-shu"))

(defun shu-exwm-screenshot ()
  "Take a screenshot."
  (interactive)
  (shu-exwm-start-process-gui-command "spectacle"))

(defun shu-exwm-screenshot-area ()
  "Take a screenshot of a mouse selected area."
  (interactive)
  (shu-exwm-start-process-gui-command "spectacle"))

(defun shu-exwm-d-launcher ()
  "Open rofi desktop app launcher."
  (interactive)
  (shu-exwm-start-process-gui-command "rofi -show drun"))

(defvar shu-exwm-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "s-`") 'shu-toggle-frame-transparency)
    (define-key map (kbd "s-r") 'exwm-reset) ;; reset to line mode
    (define-key map (kbd "s-d") 'exwm-workspace-delete)
    (define-key map (kbd "s-a") 'exwm-workspace-add)
    (define-key map (kbd "s-w") 'exwm-workspace-swap)
    (define-key map (kbd "s-k") 'kill-current-buffer)
    (define-key map (kbd "s-K") (lambda () (interactive)
                                  (kill-current-buffer)(delete-window)))
    (define-key map (kbd "s-<return>") 'multi-vterm)
    (define-key map (kbd "s-s") 'shu-exwm-d-launcher)
    (define-key map (kbd "<print>") 'shu-exwm-screenshot-area)
    (define-key map (kbd "s-<print>") 'shu-exwm-screenshot)
    (define-key map (kbd "s-l") 'shu-exwm-lock-screen)
    (define-key map (kbd "s-<up>") 'windmove-up)
    (define-key map (kbd "s-<down>") 'windmove-down)
    (define-key map (kbd "s-<right>") 'windmove-right)
    (define-key map (kbd "s-<left>") 'windmove-left)
    (define-key map (kbd "s-S-<up>") 'windmove-swap-states-up)
    (define-key map (kbd "s-S-<down>") 'windmove-swap-states-down)
    (define-key map (kbd "s-S-<right>") 'windmove-swap-states-right)
    (define-key map (kbd "s-S-<left>") 'windmove-swap-states-left)
    (define-key map (kbd "s-p") 'windmove-up)
    (define-key map (kbd "s-n") 'windmove-down)
    (define-key map (kbd "s-f") 'windmove-right)
    (define-key map (kbd "s-b") 'windmove-left)
    (define-key map (kbd "s-P") 'windmove-swap-states-up)
    (define-key map (kbd "s-N") 'windmove-swap-states-down)
    (define-key map (kbd "s-F") 'windmove-swap-states-right)
    (define-key map (kbd "s-B") 'windmove-swap-states-left)
    (define-key map (kbd "s-g") 'exwm-floating-toggle-floating)
    (define-key map (kbd "s-+") ;; We always need to stay in line mode.
                `(lambda ()
                   (interactive)
                   (let ((id (exwm--buffer->id (current-buffer))))
                     (exwm-layout-toggle-fullscreen id)
                     (exwm-input-grab-keyboard id))))
    (dotimes (i 11)
      (define-key map (kbd (format "s-%d" (mod i 10)))
                          `(lambda ()
                             (interactive)
                             (exwm-workspace-switch-create ,(- i 1))))
      (define-key map (kbd (concat "s-"
                                       (pcase (mod i 10)
                                         (1 "!") (2 "@") (3 "#") (4 "$") (5 "%")
                                         (6 "^") (7 "&") (8 "*") (9 "(") (0 ")"))))
                          `(lambda ()
                             (interactive)
                             (exwm-workspace-move-window ,(- i 1))
                             (exwm-workspace-switch ,(- i 1)))))
    map);MARK ;; see ../../emacs-exwm.nix
  "Keymap for shu's exwm shortkeys.")

(use-package exwm
  :config
  (defun exwm-rename-buffer () ;; show app name in every exwm buffer
    (interactive)
    (exwm-workspace-rename-buffer
     (concat exwm-class-name ":"
             (if (<= (length exwm-title) 50) exwm-title
               (concat (substring exwm-title 0 49) "...")))))
  (add-hook 'exwm-update-class-hook 'exwm-rename-buffer)
  (add-hook 'exwm-update-title-hook 'exwm-rename-buffer)

  (setq exwm-workspace-number 4)

  (mapcar (lambda (item)
          (pcase item
            (`(,key . ,func) (exwm-input-set-key `[,key] func))))
        (remove 'keymap shu-exwm-keymap))
  (mapcar (lambda (item) (push item exwm-input-prefix-keys))
          (mapcar 'car (remove 'keymap shu-exwm-keymap)))

  (push ?\C-q exwm-input-prefix-keys)
  (define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

  ;; simulation kkeys are keys that exwm will send to the exwm buffer upon inputting a key combination
  (setq exwm-input-simulation-keys '(([?\C-w] . ?\C-x)
                                     ([?\M-w] . ?\C-c)
                                     ([?\C-y] . ?\C-v)
                                     ([mouse-8] . ?\C-c)
                                     ([mouse-9] . ?\C-v)
                                     ([?\C-x ?h] . ?\C-a)
                                     ;; search
                                     ([?\C-s] . ?\C-f)
                                     ([?\C-x ?\C-s] . ?\C-s)))
  (setq exwm-manage-configurations
        '(((string= exwm-class-name "firefox") workspace 1)
          ((string= exwm-class-name "thunderbird") workspace 2)
          ((string= exwm-class-name "TelegramDesktop") floating t border-width 2)
          ((string= exwm-class-name "Element") floating t border-width 2)
          ((string= exwm-class-name ".blueman-manager-wrapped") floating t border-width 2 x 0 y 0)
          ((string= exwm-class-name "Qemu-kvm") char-mode t)
          ((string= exwm-class-name "MEGAsync") floating t x 0 y 0)
          ((string= exwm-class-name "spectacle") floating t border-width 2))))

(use-package exwm-ns)

(use-package desktop-environment
  :diminish
  :config
  (define-key desktop-environment-mode-map (kbd "s-l") 'shu-exwm-lock-screen)
  (define-key desktop-environment-mode-map (kbd "S-<print>") nil)
  (define-key desktop-environment-mode-map (kbd "<print>") 'shu-exwm-screenshot-area)
  (define-key desktop-environment-mode-map (kbd "<XF86ScreenSaver>") 'shu-exwm-lock-screen)
  (setq desktop-environment-update-exwm-global-keys :prefix)
  (setq exwm-layout-show-all-buffers t)
  (desktop-environment-mode))

(defun init-exwm ()
  "Init exwm without DE support."
  (progn
    ;; (add-to-list 'default-frame-alist `(alpha . (90, 90)))
    (toggle-frame-fullscreen)
    (exwm-init)
    (exwm-ns-init)
    (start-process-shell-command "firefox" nil "firefox")
    (start-process-shell-command "thunderbird" nil "thunderbird")
    (start-process-shell-command "polybar" nil "polybar")
    (start-process-shell-command "xsslock" nil "xss-lock --transfer-sleep-lock -- i3lock-shu")
    (start-process-shell-command "autolock" nil "xautolock -time 5 -locker i3lock-shu -detectsleep -notify 5 -notifier \"i3lock-shu --grace-mode 5\"")
    (start-process-shell-command "blueman" nil "blueman-applet")
    (start-process-shell-command "megasync" nil "megasync")
    (shu-exwm-start-process-gui-command "dolphin --daemon")
    ;; (start-process-shell-command "feh" nil "feh --bg-scale ~/clash-configuration/background-image")
    (exwm-workspace-switch 0)))

(provide 'shu-exwm)
;;; shu-exwm.el ends here.
