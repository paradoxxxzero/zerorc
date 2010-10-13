(setq c-default-style "k&r")
(setq c-basic-offset 8)

(global-set-key [(control x) (control a)] (lambda () (interactive) (slime-connect "127.0.0.1" 4343)))
(global-set-key [(control x) (control y)] 'clojure-enable-slime-on-existing-buffers)
(global-set-key "\M-[1;5C" 'forward-word)   ;  Ctrl+right->forward word
(global-set-key "\M-[1;5D" 'backward-word)  ;  Ctrl+left-> backward word
(global-set-key "\M-[1;5A" 'backward-paragraph)
(global-set-key "\M-[1;5B" 'forward-paragraph)


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
 ;;'(bar-cursor-mode t nil (bar-cursor))
 '(home-end-enable t)
 '(initial-scratch-message nil)
 '(remote-shell-program "zsh")
 '(visible-bell t)
 '(hl-paren-colors '("red" "lightblue" "green" "lightpink" "lightyellow")))

(setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
			 ("gnu" . "http://elpa.gnu.org/packages/")))

(require 'color-theme)
(color-theme-initialize)
(color-theme-charcoal-black)
