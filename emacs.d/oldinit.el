;; ;; Screenshot
;; (cond
;;  (nil
;;   (setq
;;    jmc-project-dir "~/src/screenshot.git/digisynd/screenshot"
;;    jmc-project-name "work"
;;    jmc-project-spec "~/Documents/task-screenshot.txt"
;;    jmc-project-ref "~/src/basset/digisynd/basset/basset.py"
;;    jmc-nose-program	"/home/johnm/src/screenshot.git/bin/nosetests"
;;    compile-command "~/src/screenshot.git/bin/digisynd-screenshot"
;;    ))
;;  (nil
;;   (setq
;;    jmc-project-dir 	"~/src/bone/digisynd/bone"
;;    jmc-project-spec 	"~/Documents/task-screenshot.txt"
;;    jmc-project-ref 	"~/src/basset/digisynd/basset/basset.py"
;;    jmc-nose-program	"~/src/bone/bin/nosetests"
;;    jmc-project-name 	"bone"
;;    ))
;;  (nil
;;   (setq
;;    jmc-project-name 	"replace"
;;    jmc-project-dir 	"~/src/REPLACE-basset/digisynd/basset"
;;    jmc-project-spec 	"~/Documents/task-replace.txt"
;;    jmc-project-ref 	"~/src/REPLACE-basset/digisynd/basset/basset.py"
;;    jmc-nose-program	"~/src/REPLACE-basset/bin/nosetests"
;;    ))
;;  (t
;;   (setq
;;    jmc-project-name 	"indigo"
;;    jmc-project-dir 	"~/src/indigo"
;;    jmc-project-spec 	"~/Documents/indigo-tasks.txt"
;;    jmc-project-ref 	nil
;;    jmc-nose-program	nil
;;    )))

;; (when (null jmc-nose-program)
;;   (let ((projnose (format "%s/bin/nosetests" jmc-project-dir)))
;;     (setq jmc-nose-program
;; 	  (if (file-exists-p projnose) projnose "nosetests"))))

; (setq jmc-nose-program	"nosetests")



(when nil
  (defun LOG (msg &rest args)
  (save-current-buffer
    (set-buffer (get-buffer-create "*log*"))
    (goto-char (point-max))
    (let ((str (concat
		(format-time-string "%r") ": " msg "\n")))
      (insert str)
      (message str)))))



;; :::::::::::::::::::::::::::::::::::::::::::::::::: FLYMAKE

(when nil
  (when (require 'flymake)
    (set-variable 'flymake-log-level -1)
    (setq flymake-start-syntax-check-on-newline nil)
    ;; (setq flymake-no-changes-timeout 10)
    (add-hook 'java-mode-hook 'flymake-mode-on)
    (load "flymake-elisp")))


;; basic setup
(setq inhibit-startup-message t)

(add-to-list 'load-path "~/.emacs.d/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SIMPLE

;; buffer-display-count
;; buffer-display-time
(when t
  (defun jm-next-buffer ()
    (interactive)
    (next-buffer))
  (defun jm-previous-buffer ()
    (interactive)
    (previous-buffer))
; Logitech buttons on left side:
  (global-set-key [(mouse-8)] 'jm-previous-buffer)
  (global-set-key [(mouse-9)] 'jm-next-buffer))
; (require 'pabbrev)

(global-set-key 
 [f7] 	(lambda () (interactive) (find-file "~/.emacs.d/init.el" t)))
(global-set-key 
 [S-f7] 
 (lambda () (interactive) (find-file "~/.emacs.d/jmcompile.el" t)))


(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(global-set-key "\C-x;" 'comment-region)

(when t
  (add-to-list 'load-path "~/.emacs.d/icicles/")
  (require 'icicles))

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(setq frame-title-format "%b - Emacs")	; window title is buffer name

;; Do running spell check in text mode.
(add-hook 'text-mode-hook  'flyspell-mode)

;; ;; Set the dictionary for the spell check.
;; (setq flyspell-mode-hook
;;       '(lambda () "Sets the dictionary for flyspell on startup."
;; 	 (ispell-change-dictionary "svenska")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FUNCTIONS

(require 'compile)
(global-set-key "c" (quote compile))

; make *compliation* wordwrapped (via StackOverflow)
(defun jm-compilation-mode-hook ()
  (setq truncate-lines nil)
  (setq truncate-partial-width-windows nil))
(add-hook 'compilation-mode-hook 'jm-compilation-mode-hook)


(require 'python)
(defun jm-python-run ()
  (interactive)
  (python-send-buffer)
  (python-switch-to-python nil))

; enable Electric Documentation minor mode for Python:
(add-hook 'python-mode-hook
          '(lambda () (eldoc-mode 1)) t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FLYMAKE


(set-variable 'flymake-gui-warnings-enabled nil)

; "sumosync"
(set-variable 'flymake-sumo-command "jmcheck")

; (flymake-get-file-name-mode-and-masks "zoot.py")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PHP



;; (add-to-list 
;;  'compilation-error-regexp-alist
;;  '(php
;;   "\\(.*\\.php\\):\\([0-9]+\\)"
;;   1 2 nil nil 1))
;; http://github.com/ieure/phpunit-el/
;; (add-to-list 
;;  'compilation-error-regexp-alist
;;  '(("^\\(.*\\.php\\):\\([0-9]+\\)$" 	1 2 nil nil 1)))

(defvar phpunit-regexp-alist
  '(("^\\(.*\\.php\\):\\([0-9]+\\)$" 
     1 2 nil nil 1))
  "Regexp used to match PHPUnit output. See `compilation-error-regexp-alist'.")

;;  (add-hook 'php-mode-hook (lambda ()
;;     (add-to-list 'compilation-error-regexp-alist 
;;   '(("^\\(.*\\.php\\):\\([0-9]+\\)$" 
;;      1 2 nil nil 1))
;;     )))

(when nil
  (require 'php-mode)
  (require 'flymake-php)
  
  (add-hook 'php-mode-hook
	    (lambda ()
	      (local-set-key (kbd "<tab>") 'indent-according-to-mode)
	      )))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; EMACS-LISP

(when t
  (defun jm-eval-to-here ()
    (interactive)
    (eval-region 0 (point)))
  (global-set-key [f9] 'jm-eval-to-here))

  
(defun jm-evalbuf ()
  "Evaluate entire buffer, displaying output of print statements.
Run function 'test'.
"
  (interactive)
  (save-excursion
    (goto-char 0)
    (eval-buffer nil nil nil nil t))
  (test))

(defun jm-emacs-lisp-hook ()
  (define-key emacs-lisp-mode-map '[S-right] 'lisp-complete-symbol)
  (define-key emacs-lisp-mode-map [kp-enter] 'jm-evalbuf)
  (define-key emacs-lisp-mode-map [kp-add] 'elint-current-buffer))

(add-hook 'emacs-lisp-mode-hook 'jm-emacs-lisp-hook)

;; XX:
(let ((map emacs-lisp-mode-map))
  (define-key map '[S-right] 'lisp-complete-symbol))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PYTHON


(require 'flymake-sumo)
; (require 'flymake-pylint)

; XXX: doesnt work:
(when nil
  (let ((map python-mode-map))
    (define-key map '[kp-insert] 'jmc-py-nose)
    (define-key map '[S-right] 'python-complete-symbol)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; KEYS

;; http://www.gnu.org/software/emacs/manual/html_node/emacs/Function-Keys.html

(global-set-key [kp-insert] 'next-error)
(global-set-key [C-kp-insert] 'flymake-goto-next-error)






;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: GNUSERV
;;

(when nil
  (load "gnuserv-compat")
  (load-library "gnuserv")
  (gnuserv-start))

;; test with:
;; % gnuclient --batch --eval '(message "beer")'


;; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: PYMACS
;;

;; (when nil
;;   (autoload 'pymacs-apply "pymacs")
;;   (autoload 'pymacs-call "pymacs")
;;   (autoload 'pymacs-eval "pymacs" nil t)
;;   (autoload 'pymacs-exec "pymacs" nil t)
;;   (autoload 'pymacs-load "pymacs" nil t))
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))

;; ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


;; Firefox Read-Eval-Print Loop!
;; http://hyperstruct.net/projects/mozrepl


;; ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;; http://emacs-fu.blogspot.com/2009/04/dot-emacs-trickery.html

(defun tj-find-file-check-make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 1024 1024))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (message "Buffer is set to read-only because it is large. Undo also disabled.")))


(add-hook 'find-file-hooks 'tj-find-file-check-make-large-file-read-only-hook)

;; allow shift + arrow for selections
(pc-selection-mode t)


(when nil
  ;; Easy buffer switching by holding down shift and press any arrow key.
  (windmove-default-keybindings 'shift))

;; Always add a final newline
;; XX? (setq require-trailing-newline t)

;; Menu bars are free on OS X – the space is used whether they're
;; enabled or not – but a waste anywhere else.
; (menu-bar-mode (if (eq 'ns window-system) 1 -1))
; (menu-bar-mode t)

;; uniquify!
(when (require 'uniquify)
  (setq uniquify-buffer-name-style 'reverse)
  (setq uniquify-separator "|")
  (setq uniquify-after-kill-buffer-p t)
  (setq uniquify-ignore-buffers-re "^\\*"))



;; Make URLs in comments/strings clickable
;(add-hook 'find-file-hooks 'goto-address-prog-mode)

;; eldoc for quick reference
(when (require 'eldoc)
  (autoload 'turn-on-eldoc-mode "eldoc" nil t)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode))

;; fm package that highlights corresponding line in source buffer as
;; one moves through the output (occur, compilation, ...) buffer.
(when nil
  (require 'fm)
  (add-hook 'occur-mode-hook 'fm-start)
  (add-hook 'compilation-mode-hook 'fm-start))
;; Once following is activated in a buffer, it can be toggled with the
;; "f" key in that buffer.


(transient-mark-mode t)
(setq-default truncate-lines nil)


;; disable C-z on X11 sessions
(when window-system
  (global-unset-key "\C-z"))

;; Remember position in files between sessions
(when (require 'saveplace)
  (setq-default save-place t))

;; ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((jmc-testargs . "flymake.el") (jmc-testargs . flymake\.el)))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(flymake-errline ((default nil) (nil (:background "bisque1")))))

; (list-colors-display)

; XXXX: must be at end??
;; XX: simple.el puts this as "undo"?
(global-set-key (kbd "M-DEL") 'backward-kill-word)


(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . espresso-mode))
(autoload 'espresso-mode "espresso" nil t)
(eval-after-load "espresso"
  '(progn 
     (defun espresso-custom-setup ()
       (moz-minor-mode 1))
     (add-hook 'espresso-mode-hook 'espresso-custom-setup)))

(defun jm-moz-reload ()
  "Save buffers, reload current Firefox page."
  (interactive)
  (save-some-buffers t)
  (with-temp-buffer
    (insert "BrowserReload();")
    (moz-send-defun)))
; (jm-moz-reload)
; (global-set-key [kp-add] 'jm-moz-reload)
      


(when (require 'flymake)
  (set-variable 'flymake-log-level -1)
  (setq flymake-start-syntax-check-on-newline nil)
  ; (setq flymake-no-changes-timeout 10)
  (add-hook 'java-mode-hook 'flymake-mode-on))

(require 'jmcompile)
