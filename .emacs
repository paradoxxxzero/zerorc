(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))
(require 'basic-edit-toolkit)
(setq c-default-style "k&r")
(setq c-basic-offset 8)

(global-set-key [(control x) (control a)] (lambda () (interactive) (slime-connect "127.0.0.1" 4343)))
(global-set-key [(control x) (control y)] 'clojure-enable-slime-on-existing-buffers)

(global-set-key (kbd "C-SPC") 'dabbrev-expand)
(global-set-key (kbd "M-SPC") 'set-mark-command)

(global-set-key [M-up] 'move-text-up)
(global-set-key [M-down] 'move-text-down)
(global-set-key [s-up] 'duplicate-line-or-region-above)
(global-set-key [s-down] 'duplicate-line-or-region-below)

(defun make-backup-file-name (file)
  (concat "~/.emacs-backup/" (file-name-nondirectory file) "~"))

(menu-bar-mode -1)
(setq column-number-mode t)
(setq line-number-mode t) 
(setq inhibit-startup-message t )

(defun backward-kill-line (arg)
  "Kill chars backward until encountering the end of a line."
  (interactive "p")
  (kill-line 0))

;; you may want to bind it to a different key
(global-set-key "\C-u" 'backward-kill-line)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-paren-colors (quote ("red" "lightblue" "green" "lightpink" "lightyellow")))
 '(home-end-enable t)
 '(initial-scratch-message nil)
 '(menu-bar-mode nil)
 '(remote-shell-program "zsh")
 '(tool-bar-mode nil)
 '(visible-bell t))

(setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
			 ("gnu" . "http://elpa.gnu.org/packages/")))

(require 'color-theme)
(color-theme-initialize)
(color-theme-charcoal-black)
(custom-set-faces '(default ((t (:height 110 :family "monofur" :embolden t)))))
