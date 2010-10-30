
;; M-x which-function-mode

;; basic setup
(setq inhibit-startup-message t)

(set-variable 'project-dir "~/src/xx") ;XXX

(set-foreground-color "white")
(set-background-color "black")

(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/internet/")
;; (add-to-list 'load-path "~/.emacs.d/internet/sml-mode-4.1")


(defun jmc-eval-to-here ()
    (interactive)
    (eval-region 0 (point)))
(global-set-key [f9] 'jmc-eval-to-here)


;; :::::::::::::::::::::::::::::::::::::::::::::::::: GLOBAL TWEAKS

(desktop-save-mode 1)

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; window title is buffer name
(setq frame-title-format 
      (format "@%s %%b - Emacs" system-name))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(tool-bar-mode -1)
(setq py-mode-map (make-sparse-keymap))	; XX fix whine

;; :::::::::::::::::::::::::::::::::::::::::::::::::: DEVELOPMENT

; rebind complete-symbol (lisp & python) away from M-tab, which the
; window manager grabs, to ...
;
(global-set-key '[backtab] 'symbol-complete)
(define-key emacs-lisp-mode-map '[backtab] 'lisp-complete-symbol)

; symbol-complete = ?
; complete-symbol = from TAGS
; lisp-complete-symbol

(eval-after-load "python"
  (load "jm-python"))			; fix python-describe-symbol


;; (if (boundp 'makefile-mode-map)
;;     (define-key makefile-mode-map [kp-enter] 'jmc-make-fast))

; IP 10.x.x.x = work, else=home
(defun jm-workp ()
  "at work"
  (= 10 (elt (car (network-interface-info "eth0")) 0)))
;; (jm-workp)
(global-set-key [kp-insert] 'jmc-next)



;; :::::::::::::::::::::::::::::::::::::::::::::::::: COMPILE MODE

(require 'compile)

(setq compilation-scroll-output 'first-error)

(defun jm-compilation-mode-hook ()
  "make *compliation* buffer wordwrapped (via StackOverflow)"
  (setq truncate-lines nil)
  (setq truncate-partial-width-windows nil))
(add-hook 'compilation-mode-hook 'jm-compilation-mode-hook)




;; :::::::::::::::::::::::::::::::::::::::::::::::::: ELDOC
;; Eldoc for quick reference

(when t
  (autoload 'turn-on-eldoc-mode "eldoc" nil t)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
  ;; (add-hook 'python-mode-hook 'turn-on-eldoc-mode)
  )


;; :::::::::::::::::::::::::::::::::::::::::::::::::: MISC MINOR

(when t
  (setq which-func-modes t)
  (which-func-mode 1))
(when nil
  (global-set-key (kbd "C-<tab>") 'dabbrev-expand)
  (define-key minibuffer-local-map (kbd "C-<tab>") 'dabbrev-expand))

(when (require 'ido)
  (ido-mode t)
  (setq ido-enable-flex-matching t)) ;; enable fuzzy matching
  



;; M-s h p = highlight-phrase
(require 'hi-lock)
(global-hi-lock-mode 1)

(setq ispell-program-name "aspell" 
      ispell-extra-args '("--sug-mode=ultra"))

(add-hook 'org-mode-hook
  (lambda() (flyspell-mode 1)))

(autoload 'tail-file "internet/tail"
  "Tails file specified with argument ``file'' inside a new buffer." t)
(setq tail-volatile nil)

(when nil
  ;; M-] M-/ = search for word at point in all files in repository
  (load "emacswikipages/grep-o-matic" t t)
  
  (autoload 'hide-lines "emacswikisrc/hide-lines"
    "Hide lines based on a regexp" t)
  (global-set-key "\C-ch" 'hide-lines))


(when (require 'org-install)
  (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map "\C-ca" 'org-agenda)
  ; (setq org-log-done nil)
  )

;; :::::::::::::::::::::::::::::::::::::::::::::::::: PYTHON

(require 'python)
; https://bugs.launchpad.net/python-mode/+bug/505295
(setq py-pdbtrack-stack-entry-regexp
      "^> \\(.*\\)(\\([0-9]+\\))\\([?a-zA-Z0-9_<>]+\\)()")

(add-to-list 'auto-mode-alist '("\\.egg\\'" . archive-mode))


;; :::::::::::::::::::::::::::::::::::::::::::::::::: SUNLIGHT

;; XXXX:
;(require 'project)

(load "~/src/sunlight/project" t)
(load "~/src/sunlight/cashelper" t)
(load "~/src/sunlight/jmcompile" t)
(load "~/src/sunlight/nosetests" t)



;; :::::::::::::::::::::::::::::::::::::::::::::::::: LUA

(when t
  (setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
  (autoload 'lua-mode "lua-mode" "Lua editing mode." t)
  (add-hook 'lua-mode-hook 'turn-on-font-lock))
(when nil
  (require 'lua-mode)
  (setq lua-mode-map (make-sparse-keymap))
  (defun jmc-awesome-reload ()
    (interactive)
    (jmc-make "awesome -k && killall -HUP awesome"))
  (define-key lua-mode-map [kp-enter] 'jmc-awesome-reload))




;; :::::::::::::::::::::::::::::::::::::::::::::::::: PDB

;; http://twistedmatrix.com/trac/browser/trunk/emacs/twisted-dev.el

(add-hook 
 'pdb-mode-hook
 (lambda ()
   (gud-def gud-break  "break %d%f:%l"  "\C-b" 
	    "Set breakpoint at current line.")
   (gud-def gud-tbreak "tbreak %d%f:%l" "\C-t"
	    "Set temporary breakpoint at current line.")
   (gud-def gud-remove "clear %d%f:%l" "\C-d" 
	    "Remove breakpoint at current line")))


;; :::::::::::::::::::::::::::::::::::::::::::::::::: TAGS

;; M-.  find tag under cursor, where tag is a *symbol*
;; M-,  find next matching *symbol*
;;

(setq tags-revert-without-query t
      tags-case-fold-search nil)

;; (tags-search "^def search(")
;; (tags-apropos "search")
(global-set-key (kbd "M-?") 'tags-apropos)

(defun tag-py-outer-match-p (tag)
  "Return non-nil if TAG defined at outer level of Python source;
class or function."
  (tag-re-match-p (format "^def %s(" tag)))

(defun jmc-set-match-order ()
  (interactive)
  (setq find-tag-tag-order .
	(;; tag-py-outer-match-p
	 ;; tag-exact-file-name-match-p
	 ; tag-file-name-match-p
	 ;; tag-exact-match-p
	 ;; tag-implicit-name-match-p
	 'tag-symbol-match-p
	 ;; tag-word-match-p
	 ;; tag-partial-file-name-match-p
	 ;; tag-any-match-p
	 )))

;; find-tag-tag-order is a variable defined in `etags.el'.
;; (tag-exact-file-name-match-p tag-file-name-match-p
;; tag-exact-match-p tag-implicit-name-match-p tag-symbol-match-p
;; tag-word-match-p tag-partial-file-name-match-p tag-any-match-p)


;; :::::::::::::::::::::::::::::::::::::::::::::::::: FLYNOTE
;; (eval-after-load "edebug" '(def-edebug-spec c-point t))

(when t
  (unless (file-exists-p "flynote.el")
    (add-to-list 'load-path "~/src/flynote1/"))
  (require 'flynote nil t))


;; :::::::::::::::::::::::::::::::::::::::::::::::::: KEYS
;; after all the modes are loaded

;; (when (require 'hideshow-fringe)
;;   (dolist (hook (list
;; 		 'emacs-lisp-mode-hook
;; 		 'python-mode-hook
;; 		 ))
;;     (add-hook hook 'hs-minor-mode)))
    ;; (add-hook hook 'hideshowvis-enable)))

;; edit init or jmcompile:

(global-set-key [f7] (lambda () (interactive) 
		       (find-file "~/.emacs.d/init.el" t)))
(global-set-key [S-f7] (lambda () (interactive) 
			 (find-file "~/src/sunlight/jmcompile.el" t)))

(global-set-key [C-kp-insert] 'next-error)
(global-set-key [f8] 'bury-buffer)
(global-set-key (kbd "C-x ;") 'comment-region)
(global-set-key (kbd "C-x c") 'compile)
(global-set-key (kbd "C-x g") 'grep)
(global-set-key (kbd "C-x m") 'manual-entry)

(global-set-key [kp-delete] 'jmc-pdb-thisfunc)
(global-set-key [kp-enter] 'jmc-make-recompile)
(global-set-key [kp-add]   'jmc-nose-tree)
(global-set-key [kp-subtract] 'flynote-pylint-disable-msg)

(define-key python-mode-map (kbd "C-h f")	'python-describe-symbol)

(define-key python-mode-map [kp-enter] 		'jmc-make-recompile)
(define-key python-mode-map [C-kp-enter] 	'jmc-nose-thisfunc)
(define-key python-mode-map [kp-add] 		'jmc-nose-file)
(define-key python-mode-map [C-kp-add] 		'jmc-nose-tree)

;; (define-key python-mode-map [kp-home]		'jmc-py-copyarg)

(define-key python-mode-map [kp-delete] 	'jmc-pdb)
(define-key python-mode-map [C-kp-delete] 	'jmc-pdb-setfunc)
(define-key python-mode-map (kbd "S-<kp-decimal>") 	'jmc-pdb-toggle)
(define-key python-mode-map (kbd "S-<kp-delete>") 	'jmc-pdb-toggle)

(when nil
  (define-key python-mode-map (kbd "C-<down>") 	'python-end-of-block)
  (define-key python-mode-map (kbd "C-<up>") 	'python-beginning-of-block))



;; :::::::::::::::::::::::::::::::::::::::::::::::::: WEIRD KEYS

;; Logitech mouse:
;; side up/down = 9/8
;; thumb = 10

;; Toshiba:
;; play/pause, prev, next, mute
;; volume=XF86AudioRaiseVolume

; later: control +/- = larger/smaller font, control 0 = default
; (X: ^0 is already bound)


;; :::::::::::::::::::::::::::::::::::::::::::::::::: THEMES (unused)

;; Change to dark colors
(defun elpowers-theme ()
  (interactive)
  (set-cursor-color "red")
  (set-foreground-color "white")
  (set-background-color "black")
  (set-face-foreground 'font-lock-function-name-face "orange"))

;; (set-face-attribute 
;;  'default nil 
;;  :height (if (jm-workp)
;; 	     ;; bling on TV: 
;; 	     85
;; 	   ;; bling on laptop:
;; 	   85))

;; tartigrade-tv:
(when (string= system-name "tartigrade.lan9") ;XX
  (set-face-attribute  'default nil  :height 120))

(when nil
  (require 'color-theme)
  ;; (color-theme-gnome2)
  ;; (set-face-font 'menu "7x14")
  (defun jm-theme-fix ()
    (interactive)
    (set-face-attribute  'default nil  :height 85))
  (defun jm-theme-install-at-point ()
    (interactive)
    (let ((themename (thing-at-point 'symbol)))
      (funcall (car (read-from-string themename)))
      (jm-theme-fix))))

;; (setq 'jm-themes
;;       (list
;;        (color-theme-lethe "Lethe" "Ivica Loncar <ivica.loncar@srk.fer.hr>")
;;        (color-theme-dark-laptop "Dark Laptop" "Laurent Michel <ldm@cs.brown.edu>")
;;        '(color-theme-ld-dark "Linh Dang Dark" "Linh Dang <linhd@nortelnetworks.com>")))
;;        (color-theme-taylor "Taylor" "Art Taylor <reeses@hemisphere.org>")
;;        (color-theme-taming-mr-arneson "Taming Mr Arneson" "Erik Arneson <erik@aarg.net>")
;;        (color-theme-charcoal-black "Charcoal Black" "Lars Chr. Hausmann <jazz@zqz.dk>")
;;        (color-theme-euphoria "Euphoria" "oGLOWo@oGLOWo.cjb.net")
;;        (color-theme-late-night "Late Night" "Alex Schroeder <alex@gnu.org>")
;;        (color-theme-matrix "Matrix" "Walter Higgins <walterh@rocketmail.com>")
;;        (color-theme-midnight "Midnight" "Gordon Messmer <gordon@dragonsdawn.net>")
;;        (color-theme-robin-hood "Robin Hood" "Alex Schroeder <alex@gnu.org>")
;;        (color-theme-subtle-hacker "Subtle Hacker" "Colin Walters <levanti@verbum.org>")
;;        (color-theme-tty-dark "TTY Dark" "O Polite <m2@plusseven.com>")
;;        ))

;; :::::::::::::::::::::::::::::::::::::::::::::::::: CUSTOMIZATION

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((pymacs-auto-reload . t)))))

;; elpowers:
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 103 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))


(when (string= system-name "tartigrade.lan9") ;XX
  (set-face-attribute 'default nil :height 120))

;; :::::::::::::::::::::::::::::::::::::::::::::::::: CALENDAR/DIARY

(when (require 'calendar)
  (setq view-diary-entries-initially t
	mark-diary-entries-in-calendar t
	number-of-diary-entries 7)
  (add-hook 'diary-display-hook 'fancy-diary-display)
  (add-hook 'today-visible-calendar-hook 'calendar-mark-today))

                         
;; (REGEXP FILE [LINE COLUMN TYPE HYPERLINK HIGHLIGHT...]).
(when nil
  (push '(tie-compiler
	  "^File: \\([^,]+\\), Line: \\([0-9]+\\), \\(?:\\(Error\\)\\|\\(Warning\\)\\|\\(Message\\)\\): (\\(.+\\)),"
	  1 2 nil (4 . 5))
        compilation-error-regexp-alist-alist)
  (push  'tie-compiler compilation-error-regexp-alist))


(add-to-list 
 'compilation-error-regexp-alist 
 '("line \\([0-9]+\\)" ;;  character \\([0-9]+\\): \\(.+\\)"
   nil 1))
;; "Lint at line 12 character 1: 'window' is not defined."

(put 'suspend-frame 'disabled nil)
