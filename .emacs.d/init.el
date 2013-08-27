(require 'package)
(package-initialize)

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
;;(require 'multiple-cursors)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-*") 'mc/mark-all-like-this)
(global-set-key (kbd "s-i") 'mc/mark-all-like-this)
(global-set-key (kbd "s-I") 'mc/mark-next-like-this)
(global-set-key (kbd "C-s-I") 'mc/mark-previous-like-this)
(global-set-key (kbd "s-TAB") 'mc/edit-lines)
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)

;; Py Regexp

;; Github browse file
(global-set-key (kbd "<XF86HomePage>") 'github-browse-file)
(global-set-key (kbd "<s-XF86HomePage>") 'github-browse-file-blame)


;; Emmet Mode
;;(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook 'emmet-mode)
(global-set-key (kbd "s-SPC") 'emmet-expand-line)

;; Fiplr
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(global-set-key (kbd "C-x /") 'fiplr-find-directory)

;;;; UI
;; Git Gutter
;;(require 'git-gutter)
(global-git-gutter-mode t)

;; Raibow Delimiters
;;(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)

;; Ido Ubiquitous
;;(require 'ido-ubiquitous)
(setq ido-everywhere t)

;; Smex
;;(require 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Pretty-mode
;;(require 'pretty-mode)
(global-pretty-mode 1)


;;;; Modes
;; Coffee Mode

;; Sass Mode

;; Jinja2 Mode

;; Js3 Mode

;;;; Check
;; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)


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

(global-set-key (kbd "<f6>") 'mark-previous-like-this)
(global-set-key (kbd "<f7>") 'mark-next-like-this)
(global-set-key (kbd "<f8>") 'mc/edit-lines)
(global-set-key (kbd "<f9>") 'sort-lines)
(global-set-key (kbd "<f10>") 'rainbow-mode)
(global-set-key (kbd "<f11>") 'delete-trailing-whitespace)

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


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#292929" "#ff3333" "#aaffaa" "#aaeecc" "#aaccff" "#FF1F69" "#aadddd" "#999999"])
 '(background-color "#202020")
 '(background-mode dark)
 '(backup-by-copying t)
 '(backup-by-copying-when-linked t)
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(column-number-mode t)
 '(css-indent-offset 2)
 '(cursor-color "#cccccc")
 '(custom-safe-themes (quote ("998e84b018da1d7f887f39d71ff7222d68f08d694fe0a6978652fb5a447bdcd2" default)))
 '(foreground-color "#cccccc")
 '(hippie-expand-dabbrev-as-symbol t)
 '(hippie-expand-try-functions-list (quote (try-expand-all-abbrevs try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name-partially try-complete-file-name try-expand-list try-expand-line try-expand-google-spelling try-expand-google)))
 '(ido-ignore-files (quote ("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./" "\\`__pycache__/")))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(js3-indent-level 4)
 '(menu-bar-mode nil)
 '(recentf-max-menu-items 255)
 '(recentf-max-saved-items 255)
 '(recentf-mode t)
 '(require-final-newline t)
 '(scroll-bar-mode nil)
 '(scss-compile-at-save nil)
 '(show-trailing-whitespace t)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#110F13" :foreground "#F4EAD5" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight semi-bold :height 113 :width normal :foundry "adobe" :family "Source Code Pro"))))
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
 '(rainbow-delimiters-unmatched-face ((t (:foreground "red1")))))
(put 'scroll-left 'disabled nil)
