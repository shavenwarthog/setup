(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/internet/")

;; :::::::::::::::::::::::::::::::::::::::::::::::::: SAFE TOOLS
 
(global-set-key
 [f7]
 (lambda () (interactive)
   (find-file "~/.emacs.d/init.el" t)))

(defun jmc-eval-to-here ()
    (interactive)
    (eval-region 0 (point)))
(global-set-key [f9] 'jmc-eval-to-here)

(global-set-key [f8] 'bury-buffer)
(global-set-key (kbd "C-x ;") 'comment-region)


;; http://www.reddit.com/r/emacs/comments/1aqbx4/what_would_be_your_minimal_initel_file/

;; basic stuff
(show-paren-mode 1)
(setq-default indent-tabs-mode nil
              vc-handled-backends nil
              make-backup-files nil)

;; ido
(when (require 'ido)
  (ido-mode t)
  (setq 
   ido-create-new-buffer (quote never)
   ido-enable-flex-matching t ;; enable fuzzy matching
   ido-enable-last-directory-history nil
   ido-enable-regexp nil
   ido-max-directory-size 10000
   ;; ido-max-file-prompt-width 0.1        ;??
   ;; ido-use-filename-at-point (quote guess) ;??
   ;; ido-use-url-at-point t                  ;??
   ido-use-virtual-buffers t))

;; :::::::::::::::::::::::::::::::::::::::::::::::::: DJANGO

(when t
  (add-to-list 'load-path "~/.emacs.d/pony-mode/src")
  (require 'pony-mode))

;; :::::::::::::::::::::::::::::::::::::::::::::::::: PACKAGING

(when (require 'package)
  (add-to-list 'package-archives
               '("marmalade" . "http://marmalade-repo.org/packages/") t)
  (package-initialize))


;; ################################################## HISTORICAL

;; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: HTML+JS

;; (when t
;;   (add-to-list 'load-path "~/.emacs.d/multi-web-mode/")
;;   (require 'multi-web-mode)
;;   (setq mweb-default-major-mode 'html-mode)
;; ;;   (setq mweb-default-major-mode 'nxml-mode)
;;   (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
;; 		    (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
;; 		    (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
;;   (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
;;   (multi-web-global-mode 1))

;; ; 
;; ; 
;; ; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: PACKAGING
;; ; 
;; ; ;; (when nil
;; ; ;;   (require 'package)
;; ; 
;; ; (setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
;; ;                           ("gnu" . "http://elpa.gnu.org/packages/")
;; ;                           ("marmalade" . "http://marmalade-repo.org/packages/")))
;; ;   
;; ; ;; )
;; ; ;; (package-install 'bookmark+)
;; ; (when nil
;; ;   (add-to-list 'load-path "~/.emacs.d/elpa/bookmark+-20111214")
;; ;   (require 'bookmark+))
;; ; 
;; ; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: PACKAGING
;; ; 
;; ; (setq package-archives 
;; ;       '(("ELPA" . "http://tromey.com/elpa/") 
;; ; 	("gnu" . "http://elpa.gnu.org/packages/")
;; ; 	("marmalade" . "http://marmalade-repo.org/packages/")))
;; ; 
;; ; 
;; ; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: PERL
;; ; ;
;; ; ;; https://github.com/bricoleurs/bricolage/wiki/coding-standards ?
;; ; 
;; ; (when nil
;; ;   (require 'cperl-mode)
;; ;   (fset 'perl-mode 'cperl-mode)
;; ;   
;; ;   (require 'perldoc)
;; ;   
;; ;   (add-to-list 'auto-mode-alist '("\\.t$" . cperl-mode))
;; ; 
;; ;   (defun jmc-cperl-mode-hook ()
;; ;     ;; SendGrid ~ GNU style with braces aligned with control words
;; ;     (cperl-set-style "GNU")
;; ;     (setq cperl-continued-brace-offset -2
;; ; 	  indent-tabs-mode nil
;; ; 	  c-basic-offset 2
;; ; 	  cperl-indent-level 2)
;; ;     (show-paren-mode 1)
;; ;     (local-set-key (kbd "C-h f") 'perldoc-at-point))
;; ;   
;; ;   (setq cperl-mode-hook 'jmc-cperl-mode-hook))
;; ; 
; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: TWEAKS
; 

(tool-bar-mode -1)
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; (global-set-key (kbd "<f5>") 'kmacro-end-and-call-macro)
;; (global-set-key (kbd "<f6>") 'next-error)

;; ; (add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
;; ; 
;; ; 
;; ; 
;; (which-function-mode)
;; (setq use-file-dialog nil)
;; (setq-default tab-width 4)
;; ; 
;; ; 
;; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: MODULES

;; (when (require 'ibuffer)
;;   (defalias 'list-buffers 'ibuffer))


;; (when (require 'ido)
;;   (ido-mode t)
;;   (setq ido-max-directory-size 10000
;;         ido-enable-flex-matching t)) ;; enable fuzzy matching

;; (global-set-key 
;;  (kbd "C-x i")
;;  (lambda () 
;;    (interactive)
;;    (insert-register 49)))				; "1"




;; (when t
;;   (require 'python)
;;   (load "~/src/sunlight/logme" t)
;;   (define-key python-mode-map (kbd "<f10>") 'jm-logme)
;;   ;; (define-key python-mode-map (kbd "C-<f10>") 'jm-if0)
;;   (global-set-key (kbd "C-<f10>") 'jm-if0)
  
;;   (load "~/src/sunlight/goodvalue" t)
;;   (define-key python-mode-map (kbd "S-<f10>") 'jm-insert-goodvalue))

;; ;;  (define-key js-mode-map (kbd "<f10>") 'jm-logme)
;; ;;  (define-key mweb-mode-map (kbd "C-<f10>") 'jm-if0)


;; ;; TODO: optimize
;; (when (load "js")
;;   (define-key js-mode-map (kbd "<f10>") 'jm-logme)
;;   (define-key html-mode-map (kbd "<f10>") 'jm-logme)
;;   (define-key js-mode-map (kbd "M-.") 'find-tag))

;; ;; M-/ dabbrev-expand
;; (when nil
;;   (when (require 'pymacs)
;;     (setq ropemacs-confirm-saving nil)
;;     (pymacs-load "ropemacs" "rope-")))


;; ;; (local-set-key;; M-/ dabbrev-expand
;; ;; (define-key python-mode-map (kbd "M-/") 'dabbrev-expand)




;; (when nil
;;   (add-to-list 'load-path "~/.emacs.d/yasnippet")
;;   (require 'yasnippet)
;;   (yas-global-mode 1))

;; ; 
;; :::::::::::::::::::::::::::::::::::::::::::::::::: FLYNOTE


(require 'python)
(when t
  (load "~/src/flynote/flynote" t)
  (define-key python-mode-map (kbd "C-<return>") 'flynote-check))

;; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: GNUPLOT


;; (if nil
;;     (when (load "gnuplot" t)
;;       (defun jmc-call-gnuplot-on-buffer ()
;; 	(interactive)
;; 	(save-some-buffers t)
;; 	(call-gnuplot-on-buffer))
;;       (add-to-list 'auto-mode-alist '("\\.plt$" . gnuplot-mode))
;;       (define-key gnuplot-mode-map (kbd "C-S-<return>") 
;; 	'jmc-call-gnuplot-on-buffer)))


;; :::::::::::::::::::::::::::::::::::::::::::::::::: KEYS

(global-set-key (kbd "C-x c") 'compile)
(global-set-key (kbd "C-<return>") 'recompile)
(global-set-key (kbd "C-x g") 'grep)
;; (global-set-key (kbd "C-S-<return>") 'recompile)
;; ; 
;; ; (global-set-key
;; ;  (kbd "C-S-<f8>")
;; ;  (lambda () (interactive)
;; ;    (load "init")))
;; ; 
;; ; 
;; ; 
;; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: COMPILATION
;; ; 
;; ; 
;; (setq compilation-ask-about-save nil)
;; ; 
; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: CUSTOM
; 
; ; ;; :height 120 "this is an integer in units of 1/10 point"
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:background "black" :foreground "white" :height 120)))))
; 
; 
; 
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.bmk")
 '(inhibit-startup-screen t))

;; ; 
;; ; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: HISTORICAL
;; ; 
;; ; 
;; ; ;; )
;; ; ;; (package-install 'bookmark+)
;; ; (when nil
;; ;   (add-to-list 'load-path "~/.emacs.d/elpa/bookmark+-20111214")
;; ;   (require 'bookmark+))
;; ; 
;; ; ;; http://avdi.org/devblog/2011/10/06/required-packages-emacs-reboot-12/
;; ; (when nil
;; ;   (setq package-archives
;; ; 	'(("gnu" . "http://elpa.gnu.org/packages/")
;; ; 	  ("marmalade" . "http://marmalade-repo.org/packages/")
;; ; 	  ("Tromey" . "http://tromey.com/elpa/")))
;; ;   (package-initialize)
;; ;   (setq abg-required-packages
;; ; 	(list 'xml-rpc 'magit 'gh))
;; ;   (dolist (package abg-required-packages)
;; ;     (when (not (package-installed-p package))
;; ;       (package-refresh-contents)
;; ;       (package-install package))))
;; ; 
;; ; 
;; ; 
;; ; 
;; ;   ;; (defvaralias 'c-basic-offset 'tab-width)
;; ;   ;; (defvaralias 'cperl-indent-level 'tab-width)
;; ; 
;; ; ;; (make-variable-buffer-local 'tab-width)
;; ; 
;; ; ;; sudo aptitude install emacs-goodies-el
;; ; ;; (require 'info-look)
;; ; ;; (require 'bookmark+)
;; ; 
;; ;   ;; (require 'smart-tabs)
;; ;   ;; (smart-tabs-advice cperl-indent-line cperl-indent-level)
;; ; ;; (eval-after-load "compile" '(require 'compilation-perl))
;; ; 
;; ; ;; (add-hook 'before-save-hook 'whitespace-cleanup)
;; ; 
;; ; ;; (server-start t)
;; ; ;; ;; (desktop-save-mode 1)
;; ; ;; (setq redisplay-dont-pause t)
;; ; 
;; ; 
;; ; ;; ;; find-tag is case sensitive for Python
;; ; ;; ;; (add-hook 'python-mode-hook (lambda () (setq case-fold-search nil)))
;; ; ;; (setq tags-case-fold-search nil)
;; ; ;; ;
;; ; 
;; ; 
;; ; ;; (require 'compile)
;; ; ;; (setq  compilation-search-path '("." "bin"))


;; ;; YED Django
;; ;; Hi-lock: (("[Rr]ender.+[Hh]tml" (0 (quote hi-yellow) t)))

;; (put 'narrow-to-region 'disabled nil)
