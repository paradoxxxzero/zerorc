(load  "~/.emacs.d/elisp/basic-edit-toolkit.el")
(setq c-default-style "k&r")
(setq c-basic-offset 8)

(global-set-key (kbd "M-SPC") 'dabbrev-expand)
(global-set-key (kbd "S-M-SPC") 'set-mark-command)
(global-set-key (kbd "M-$") 'comment-or-uncomment-region+)

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

(global-set-key "\C-u" 'backward-kill-line)

(load  "~/.emacs.d/elisp/highlight-parentheses.el")

(define-globalized-minor-mode real-global-highlight-parentheses-mode
 highlight-parentheses-mode (lambda ()
                      (if (not (minibufferp (current-buffer)))
			   (highlight-parentheses-mode 1))
                      ))
(real-global-highlight-parentheses-mode 1)

(setq hl-paren-colors
     '("orange1" "yellow1" "greenyellow" "green1" "springgreen1" "cyan1" "slateblue1" "magenta1" "purple" 
       "orange1" "yellow1" "greenyellow" "green1" "springgreen1" "cyan1" "slateblue1" "magenta1" "purple"))


(setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
			 ("gnu" . "http://elpa.gnu.org/packages/")))

(load  "~/.emacs.d/elisp/coffee-mode.el")
(load  "~/.emacs.d/elisp/nxhtml/autostart.el")
(setq mumamo-background-colors nil)


(add-to-list 'load-path "/home/zero/.emacs.d/elisp/ac")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/home/zero/.emacs.d/elisp/ac/ac-dict")
(ac-config-default)
(define-key ac-mode-map (kbd "C-SPC") 'auto-complete)

(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "epylint" (list local-file))))
  
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init)))

(add-hook 'find-file-hook 'flymake-find-file-hook)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(home-end-enable t)
 '(initial-scratch-message nil)
 '(js2-basic-offset 4)
 '(js2-cleanup-whitespace t)
 '(menu-bar-mode nil)
 '(nxhtml-autoload-web nil)
 '(remote-shell-program "zsh")
 '(rst-level-face-base-color "black")
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(vc-follow-symlinks t)
 '(visible-bell t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-candidate-face ((t (:background "black" :foreground "dark orange"))))
 '(ac-completion-face ((t (:foreground "yellow"))))
 '(ac-selection-face ((t (:background "black" :foreground "red"))))
 '(diff-file-header ((t (:foreground "DarkSlateGray3" :weight bold))))
 '(diff-header ((t (:foreground "DarkSlateGray1"))))
 '(flymake-errline ((t (:foreground "#f48a8a" :weight bold))))
 '(flymake-warnline ((t (:foreground "#e1da84"))))
 '(font-lock-builtin-face ((t (:foreground "#a4a4a4" :background "#262524"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#9933cc"))))
 '(font-lock-comment-face ((t (:italic t :foreground "#9933cc"))))
 '(font-lock-constant-face ((t (:foreground "#339999"))))
 '(font-lock-doc-face ((t (:foreground "LightSalmon"))))
 '(font-lock-function-name-face ((t (:foreground "#ffcc00"))))
 '(font-lock-keyword-face ((t (:foreground "#ff6600"))))
 '(font-lock-preprocessor-face ((t (:foreground "#aaffff"))))
 '(font-lock-reference-face ((t (:foreground "LightSteelBlue"))))
 '(font-lock-string-face ((t (:foreground "#66FF00"))))
 '(font-lock-type-face ((t (:foreground "DodgerBlue2"))))
 '(font-lock-variable-name-face ((t (:foreground "#FFFFFF"))))
 '(font-lock-warning-face ((t (:bold t :foreground "Pink"))))
 '(fringe ((t (:background "#222222"))))
 '(highlight ((t (:background "#101010"))))
 '(minibuffer-prompt ((t (:bold t :foreground "#ff6600"))))
 '(mode-line ((t (:foreground "#cccccc" :background "#222222" :box nil))))
 '(mode-line-buffer-id ((t (:foreground "#eeeeee" :background "#191919" :box nil))))
 '(mode-line-inactive ((t (:foreground "#a4a4a4" :background "#222222" :box nil))))
 '(modeline-mousable ((t (:background "#444444" :foreground "black"))))
 '(modeline-mousable-minor-mode ((t (:background "#444444" :foreground "black"))))
 '(mumamo-border-face-in ((t (:inherit font-lock-preprocessor-face :foreground "orange red" :weight bold))))
 '(mumamo-border-face-out ((t (:inherit font-lock-preprocessor-face :foreground "dark orange" :weight bold))))
 '(primary-selection ((t (:background "#101010"))))
 '(region ((t (:background "#191919"))))
 '(rst-level-1-face ((t (:foreground "DeepPink2"))) t)
 '(rst-level-2-face ((t (:foreground "PaleVioletRed3"))) t)
 '(rst-level-3-face ((t (:foreground "DarkOrchid2"))) t)
 '(secondary-selection ((t (:background "#090909"))))
 '(zmacs-region ((t (:background "#161616")))))
