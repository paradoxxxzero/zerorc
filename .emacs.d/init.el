(require 'cask "~/.zerorc/cask/cask.el")
(cask-initialize)
(add-to-list 'load-path "~/.emacs.d/local/")

;;;; Theme
;; Noctilux Theme
;; (load-theme 'noctilux t)

;; Soothe Theme
(load-theme 'soothe t)


;;;; Tools
;; Ack And A Half
(global-set-key (kbd "M-à") 'ack-and-a-half)
(global-set-key (kbd "C-à") 'ack-and-a-half-same)

;; Move text
(move-text-default-bindings)

;; Multiple Cursors
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-*") 'mc/mark-all-like-this)
(global-set-key (kbd "s-i") 'mc/mark-all-like-this)
(global-set-key (kbd "s-I") 'mc/mark-next-like-this)
(global-set-key (kbd "C-s-I") 'mc/mark-previous-like-this)
(global-set-key (kbd "s-TAB") 'mc/edit-lines)
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)

;; Visual Regexp Steroids
(require 'visual-regexp-steroids) ;; :(
(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)
;; if you use multiple-cursors, this is for you:
(define-key global-map (kbd "C-c m") 'vr/mc-mark)
(define-key esc-map (kbd "C-r") 'vr/isearch-backward)
(define-key esc-map (kbd "C-s") 'vr/isearch-forward)

;; Github browse file
(global-set-key (kbd "<XF86HomePage>") 'github-browse-file)
(global-set-key (kbd "<s-XF86HomePage>") 'github-browse-file-blame)


;; Emmet Mode
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook 'emmet-mode)
(global-set-key (kbd "s-SPC") 'emmet-expand-line)

;; Fiplr
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(global-set-key (kbd "C-x /") 'fiplr-find-directory)

;;;; UI
;; Git Gutter
(global-git-gutter-mode t)

;; Highlight numbers
(define-globalized-minor-mode global-highlight-numbers-mode
  highlight-numbers-mode
  (lambda ()
    (when (not (eq major-mode 'minibuffer-inactive-mode))
      (highlight-numbers-mode t))))
(global-highlight-numbers-mode t)

;; Highlight parentheses
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (when (not (eq major-mode 'minibuffer-inactive-mode))
      (highlight-parentheses-mode t))))
(global-highlight-parentheses-mode t)

;; Highlight symbol
(define-globalized-minor-mode global-highlight-symbol-mode
  highlight-symbol-mode
  (lambda ()
    (when (not (eq major-mode 'minibuffer-inactive-mode))
      (highlight-symbol-mode t))))
(global-highlight-symbol-mode t)

(global-set-key (kbd "C-S-<down>") 'highlight-symbol-next)
(global-set-key (kbd "C-S-<up>") 'highlight-symbol-prev)

;; Window numbering
(global-set-key (kbd "s-*") 'select-window-0)
(global-set-key (kbd "s-\"") 'select-window-1)
(global-set-key (kbd "s-«") 'select-window-2)
(global-set-key (kbd "s-»") 'select-window-3)
(global-set-key (kbd "s-(") 'select-window-4)
(global-set-key (kbd "s-)") 'select-window-5)
(global-set-key (kbd "s-@") 'select-window-6)
(global-set-key (kbd "s-+") 'select-window-7)
(global-set-key (kbd "s-\-") 'select-window-8)
(global-set-key (kbd "s-/") 'select-window-9)

;; Buffer move
(global-set-key (kbd "<S-s-up>") 'buf-move-up)
(global-set-key (kbd "<S-s-down>") 'buf-move-down)
(global-set-key (kbd "<S-s-left>") 'buf-move-left)
(global-set-key (kbd "<S-s-right>") 'buf-move-right)

;; Ido Ubiquitous
(setq ido-everywhere t)

;; Smex
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Pretty-mode
(require 'pretty-mode)
(global-pretty-mode 1)

;; Color Identifiers$
(require 'color-identifiers-mode)

;;;; Modes
;; Coffee Mode
(add-hook 'coffee-mode-hook (lambda () (modify-syntax-entry ?\@ "_")))

;; Sass Mode

;; Jinja2 Mode

;; Js3 Mode
;; glsl Mode

;;;; Check
;; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
(global-set-key (kbd "C-x <next>") 'flycheck-next-error)
(global-set-key (kbd "C-x <prior>") 'flycheck-previous-error)


;;;; Built in
;; Uniquify
(require 'uniquify)

;; IDO
(ido-mode 1)
(setq ido-enable-flex-matching t)

;; Tramp
(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))

;; Hippie Expand
(global-set-key (kbd "S-M-SPC") 'set-mark-command)
(global-set-key (kbd "M-SPC") 'hippie-expand)

;; Show Tabs
(standard-display-ascii ?\t "↹ ")

;; Only answer with y/n
(defalias 'yes-or-no-p 'y-or-n-p)

;; Tools
(global-set-key (kbd "C-$") (lambda ()
                              "Comment/Uncomment line/region"
                              (interactive)
                              (let (beg end)
                                (if mark-active
                                    (progn
                                      (setq beg (region-beginning))
                                      (setq end (region-end)))
                                  (setq beg (line-beginning-position))
                                  (setq end (line-end-position)))
                                (save-excursion
                                  (comment-or-uncomment-region beg end)))))

(global-set-key (kbd "<M-dead-circumflex>") 'delete-indentation)
(global-set-key [C-tab] 'other-window)
(global-set-key
 [C-S-tab]
 (lambda ()
   (interactive)
   (other-window -1)))

(global-set-key [C-up] (lambda (arg)
                         (interactive "p")
                         (let ((col (current-column)))
                           (save-excursion
                             (kill-whole-line arg))
                           (previous-line)
                           (move-to-column col))))

(global-set-key [C-down] (lambda (arg)
                           "Duplicate arg lines"
                           (interactive "p")
                           (let (beg end (origin (point)))
                             (if (and mark-active (> (point) (mark)))
                                 (exchange-point-and-mark))
                             (setq beg (line-beginning-position))
                             (if mark-active
                                 (exchange-point-and-mark))
                             (setq end (line-end-position))
                             (let ((region (buffer-substring-no-properties beg end)))
                               (dotimes (i arg)
                                 (goto-char end)
                                 (newline)
                                 (insert region)
                                 (setq end (point)))
                               (goto-char (+ origin (* (length region) arg) arg))))))

(global-set-key (kbd "<M-right>") 'forward-symbol)
(global-set-key (kbd "<M-left>") (lambda (arg)
                                    (interactive "p")
                                    (forward-symbol (* -1 arg))))


(global-set-key
 (kbd "C-.")
 (lambda (arg)
   "Kill arg lines backward."
   (interactive "p")
   (kill-line (- 1 arg))))


(global-set-key
 (kbd "C-x C-r")
 (lambda ()
   "Use `ido-completing-read' to \\[find-file] a recent file"
   (interactive)
   (let* ((file-assoc-list
           (mapcar (lambda (x) (cons (file-name-nondirectory x) x)) recentf-list))
          (filename-list
           (remove-duplicates (mapcar #'car file-assoc-list)
                              :test #'string=))
          (filename
           (ido-completing-read "Choose recent file: " filename-list nil t)))
     (when filename
       (find-file (cdr (assoc filename file-assoc-list)))))))




(defun shell-command-on-buffer (command)
  (shell-command-on-region (point-min) (point-max) command nil nil nil t))

(defun pygal-python ()
  (interactive)
  (shell-command-on-buffer "~/.envs/pygal/bin/python"))

(defun psql-on-region-elearning (begin end)
  (interactive "r")
  (shell-command-on-region begin end "psql -U elearning -d elearning_data" nil nil nil t))

(defun psql-on-region-hydra (begin end)
  (interactive "r")
  (shell-command-on-region begin end "psql -U hydra -d hydra" nil nil nil t))

(defun psql-on-region-pystil (begin end)
  (interactive "r")
  (shell-command-on-region begin end "psql -U pystil -d pystil" nil nil nil t))

(global-set-key (kbd "<XF86Calculator>") 'psql-on-region-elearning)
(global-set-key (kbd "<S-XF86Calculator>") 'psql-on-region-hydra)
(global-set-key (kbd "<M-XF86Calculator>") 'psql-on-region-pystil)
(global-set-key (kbd "<H-XF86Calculator>") 'psql-on-region-elearning)
(global-set-key (kbd "<H-XF86Mail>") 'psql-on-region-hydra)
(global-set-key (kbd "<H-XF86HomePage>") 'psql-on-region-pystil)

(global-set-key (kbd "s-b") (lambda ()
                              (interactive)
                              (save-excursion
                                (move-beginning-of-line nil)
                                (newline)
                                (forward-line -1)
                                (indent-for-tab-command)
                                (insert "import wdb; wdb.set_trace()"))))

(global-set-key (kbd "<f6>") 'mark-previous-like-this)
(global-set-key (kbd "<f7>") 'mark-next-like-this)
(global-set-key (kbd "<f8>") 'mc/edit-lines)
(global-set-key (kbd "<f9>") 'sort-lines)
(global-set-key (kbd "<f10>") 'rainbow-mode)
(global-set-key (kbd "<f11>") 'delete-trailing-whitespace)
(global-set-key (kbd "<mouse-8>") 'previous-buffer)
(global-set-key (kbd "<mouse-9>") 'next-buffer)

(server-start)

;;;; Hacks
(require 'ack-and-a-half)
(defun ack-and-a-half-create-type (extensions)
  (list "--type-set"
        (concat "ack_and_a_half_custom_type=" (mapconcat 'identity extensions ","))
        "--type" "ack_and_a_half_custom_type"))

;;;; Hippie Expand
(defun urlget (url)
  (let ((url-request-method        "GET")
        (url-request-extra-headers nil)
        (url-request-data nil))
        (let ((buff (url-retrieve-synchronously url)))
          (with-current-buffer buff
            (end-of-buffer)
            (move-beginning-of-line nil)
            (buffer-substring-no-properties (point) (point-max))))))

(defun urlpost (url data)
  (let ((url-request-method        "POST")
        (url-request-extra-headers `(("Content-Type" . "application/x-www-form-urlencoded")))
        (url-request-data          data))
    (let ((buff (url-retrieve-synchronously url)))
      (with-current-buffer buff
        (end-of-buffer)
        (move-beginning-of-line nil)
        (buffer-substring-no-properties (point) (point-max))))))

(defun urlpost-google-spelling (term)
  (let ((url-request-method        "POST")
        (url-request-extra-headers `(("Content-Type" . "application/x-www-form-urlencoded")))
        (url-request-data          (concat "<?xml version=\"1.0\" encoding=\"utf-8\" ?><spellrequest textalreadyclipped=\"0\" ignoredups=\"0\" ignoredigits=\"1\" ignoreallcaps=\"1\"><text>" term "</text></spellrequest>")))
    (let ((buff (url-retrieve-synchronously "http://www.google.com/tbproxy/spell?lang=en")))
      (with-current-buffer buff
        (end-of-buffer)
        (move-beginning-of-line nil)
        (let ((start (search-forward-regexp "<c.+?>" nil t)))
          (if (not start)
              nil
            (search-forward-regexp "</c>")
            (split-string (buffer-substring-no-properties start (- (point) 4)) "	")))))))

(defun parseresults (response)
  (cdr
   (split-string (replace-regexp-in-string "\\([\]\"\[]\\)" "" response) ",")))

(defun try-expand-google (old)
  (let ((expansion ()))
    (if (not old)
        (progn
          (he-init-string (he-dabbrev-beg) (point))
          (setq he-expand-list
                (if (not (equal he-search-string ""))
                    (parseresults
                     (urlget
                      (concat "http://suggestqueries.google.com/complete/search?client=firefox&hl=fr&q="
                              he-search-string)))))
          (setq he-search-loc2 0)))
    (if (not (equal he-search-string ""))
        (setq expansion (he-dabbrev-kill-search he-search-string)))
    (if (not expansion)
        (progn
          (if old (he-reset-string))
          ())
      (progn
        (he-substitute-string expansion t)
        t))))

(defun try-expand-google-spelling (old)
  (let ((expansion ()))
    (if (not old)
        (progn
          (he-init-string (he-dabbrev-beg) (point))
          (setq he-expand-list
                (if (not (equal he-search-string ""))
                    (urlpost-google-spelling he-search-string)))
          (setq he-search-loc2 0)))
    (if (not (equal he-search-string ""))
        (progn
          (setq expansion (car he-expand-list))
          (setq he-expand-list (cdr he-expand-list))))
    (if (not expansion)
        (progn
          (if old (he-reset-string))
          ())
      (progn
        (he-substitute-string expansion t)
        t))))

(setenv "EDITOR" "emacsclient")
(load-library "iso-transl")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ack-and-a-half-executable "/usr/bin/vendor_perl/ack")
 '(ack-and-a-half-prompt-for-directory t)
 '(ansi-color-names-vector ["#292929" "#ff3333" "#aaffaa" "#aaeecc" "#aaccff" "#FF1F69" "#aadddd" "#999999"])
 '(background-color "#202020")
 '(background-mode dark)
 '(backup-by-copying t)
 '(backup-by-copying-when-linked t)
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(coffee-tab-width 2)
 '(color-identifiers-always-on t)
 '(color-identifiers-timer-duration 0.25)
 '(color-identifiers:color-luminance 0.0)
 '(color-identifiers:num-colors 20)
 '(column-number-mode t)
 '(css-indent-offset 2)
 '(cursor-color "#cccccc")
 '(custom-safe-themes (quote ("998e84b018da1d7f887f39d71ff7222d68f08d694fe0a6978652fb5a447bdcd2" default)))
 '(desktop-path (quote ("~/.emacs.d/desktop")))
 '(foreground-color "#cccccc")
 '(global-color-identifiers-mode t)
 '(global-hl-line-mode t)
 '(highlight-symbol-idle-delay 0)
 '(highlight-symbol-on-navigation-p t)
 '(hippie-expand-dabbrev-as-symbol t)
 '(hippie-expand-try-functions-list (quote (try-expand-all-abbrevs try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name-partially try-complete-file-name try-expand-list try-expand-line try-expand-google-spelling try-expand-google)))
 '(hl-paren-colors (quote ("orange1" "yellow1" "greenyellow" "green1" "springgreen1" "cyan1" "slateblue1" "purple" "magenta" "orangered" "red" "pink" "white" "gray75" "gray50" "gray25" "black")))
 '(ido-ignore-files (quote ("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./" "\\`__pycache__/")))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(jinja2-user-keywords (quote ("showonmatch")))
 '(js-indent-level 2)
 '(js3-indent-level 2)
 '(menu-bar-mode nil)
 '(recentf-max-menu-items 255)
 '(recentf-max-saved-items 255)
 '(recentf-mode t)
 '(require-final-newline t)
 '(safe-local-variable-values (quote ((js2-basic-offset . 4))))
 '(sass-indent-offset 2)
 '(scroll-bar-mode nil)
 '(scss-compile-at-save nil)
 '(show-paren-delay 0)
 '(show-paren-mode t)
 '(show-paren-style (quote parenthesis))
 '(show-trailing-whitespace t)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify))
 '(window-numbering-auto-assign-0-to-minibuffer t)
 '(window-numbering-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#110F13" :foreground "#F4EAD5" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "unknown" :family "Droid Sans Mono"))))
 '(highlight-numbers-number ((t (:background "#1a2321" :foreground "#719F34"))))
 '(highlight-symbol-face ((t (:underline t))))
 '(hl-line ((t (:background "black"))))
 '(mode-line-inactive ((t (:inherit mode-line :background "#111111" :foreground "#252525" :weight light))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "orange1"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "yellow1"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "greenyellow"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "green1"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "springgreen1"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "cyan1"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "slateblue1"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "magenta1"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "purple"))))
 '(rainbow-delimiters-unmatched-face ((t (:foreground "red1"))))
 '(show-paren-match ((t (:background "#132228" :foreground "#7c9fc9"))))
 '(window-numbering-face ((t (:inherit link))) t))
(put 'scroll-left 'disabled nil)
(put 'downcase-region 'disabled nil)
