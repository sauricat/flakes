;;; shu-exwm --- Configuration of Emacs X Window Manager
;;; Commentary:
"Configuration of exwm."
;;; Code:
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

  (fringe-mode '(10 . 10))

  (setq exwm-workspace-number 4)

  (defun start-process-gui-command (cmd)
    "A temporary solution when `start-process-shell-command' doesn't work for X apps."
    ;; (progn (multi-vterm-dedicated-open) ;; temporary solution
    ;;        (vterm-send-string (format "%s\n" cmd))
    ;;        (multi-vterm-dedicated-close))
    (start-process-shell-command cmd nil cmd))
  (defun wm-lock-screen ()
    (interactive)
    (start-process-gui-command "i3lock-shu"))
  (defun wm-screenshot ()
    (interactive)
    (start-process-gui-command "set a ~/Pictures/Screenshots/$(date +%s).png; maim $a; xclip -selection clipboard $a -t image/png"))
  (defun wm-screenshot-area ()
    (interactive)
    (start-process-gui-command "set a ~/Pictures/Screenshots/$(date +%s).png; maim -s $a; xclip -selection clipboard $a -t image/png"))
  (defun wm-d-launcher ()
    (interactive)
    (start-process-gui-command "rofi -show drun"))

  (exwm-input-set-key (kbd "s-r") 'exwm-reset) ;; reset to line mode
  (exwm-input-set-key (kbd "s-d") 'exwm-workspace-delete)
  (exwm-input-set-key (kbd "s-a") 'exwm-workspace-add)
  (exwm-input-set-key (kbd "s-w") 'exwm-workspace-swap)
  (exwm-input-set-key (kbd "s-k") 'kill-this-buffer)
  (exwm-input-set-key (kbd "s-<return>") 'multi-vterm)
  (exwm-input-set-key (kbd "s-s") 'wm-d-launcher)
  (exwm-input-set-key (kbd "<print>") 'wm-screenshot-area)
  (exwm-input-set-key (kbd "s-<print>") 'wm-screenshot)
  (exwm-input-set-key (kbd "s-l") 'wm-lock-screen)
  (exwm-input-set-key (kbd "s-<up>") 'windmove-up)
  (exwm-input-set-key (kbd "s-<down>") 'windmove-down)
  (exwm-input-set-key (kbd "s-<right>") 'windmove-right)
  (exwm-input-set-key (kbd "s-<left>") 'windmove-left)
  (exwm-input-set-key (kbd "s-S-<up>") 'windmove-swap-states-up)
  (exwm-input-set-key (kbd "s-S-<down>") 'windmove-swap-states-down)
  (exwm-input-set-key (kbd "s-S-<right>") 'windmove-swap-states-right)
  (exwm-input-set-key (kbd "s-S-<left>") 'windmove-swap-states-left)
  (exwm-input-set-key (kbd "s-p") 'windmove-up)
  (exwm-input-set-key (kbd "s-n") 'windmove-down)
  (exwm-input-set-key (kbd "s-f") 'windmove-right)
  (exwm-input-set-key (kbd "s-b") 'windmove-left)
  (exwm-input-set-key (kbd "s-P") 'windmove-swap-states-up)
  (exwm-input-set-key (kbd "s-N") 'windmove-swap-states-down)
  (exwm-input-set-key (kbd "s-F") 'windmove-swap-states-right)
  (exwm-input-set-key (kbd "s-B") 'windmove-swap-states-left)
  (dotimes (i 11)
    (exwm-input-set-key (kbd (format "s-%d" (mod i 10)))
                        `(lambda ()
                           (interactive)
                           (exwm-workspace-switch-create ,(- i 1))))
    (exwm-input-set-key (kbd (concat "s-"
                                     (pcase (mod i 10)
                                       (1 "!") (2 "@") (3 "#") (4 "$") (5 "%")
                                       (6 "^") (7 "&") (8 "*") (9 "(") (0 ")"))))
                        `(lambda ()
                           (interactive)
                           (exwm-workspace-move-window ,(- i 1))
                           (exwm-workspace-switch ,(- i 1)))))

  ;; the simplest launcher, I keep it in only if dmenu eventually stopped working or something
  (exwm-input-set-key (kbd "s-S") ;; caps:none
                      (lambda (command)
                        (interactive (list (read-shell-command "$ ")))
                        (start-process-shell-command command nil command)))

  ;; an easy way to make keybindings work *only* in line mode
  (push ?\C-q exwm-input-prefix-keys)
  (define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

  ;; simulation keys are keys that exwm will send to the exwm buffer upon inputting a key combination
  (setq exwm-input-simulation-keys '(([?\C-w] . ?\C-x)
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
                                     )))
(use-package desktop-environment
  :diminish
  :config
  (define-key desktop-environment-mode-map (kbd "s-l") 'wm-lock-screen)
  (define-key desktop-environment-mode-map (kbd "S-<print>") nil)
  (define-key desktop-environment-mode-map (kbd "<print>") 'wm-screenshot-area)
  (define-key desktop-environment-mode-map (kbd "<XF86ScreenSaver>") 'wm-lock-screen)
  (setq desktop-environment-update-exwm-global-keys :prefix)
  (setq exwm-layout-show-all-buffers t)
  (desktop-environment-mode))
(defun init-exwm ()
  "Init exwm without DE support."
  (progn
    (toggle-frame-fullscreen)
    (start-process-shell-command "ibus" nil "ibus-daemon")
    (exwm-init)
    (start-process-shell-command "polybar" nil "polybar")
    (start-process-shell-command "nmapplet" nil "nm-applet")
    (start-process-shell-command "autolock" nil "xautolock -time 5 -locker i3lock-shu")
    (start-process-shell-command "xsslock" nil "xss-lock --transfer-sleep-lock -- i3lock-shu")))
(provide 'shu-exwm)
;;; shu-exwm.el ends here.
