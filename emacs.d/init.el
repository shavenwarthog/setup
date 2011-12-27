(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/internet/")

(global-set-key
 [f7]
 (lambda () (interactive)
   (find-file "~/.emacs.d/init.el" t)))

(defun jmc-eval-to-here ()
    (interactive)
    (eval-region 0 (point)))
(global-set-key [f9] 'jmc-eval-to-here)


;; :::::::::::::::::::::::::::::::::::::::::::::::::: PACKAGING

;; (when nil
;;   (require 'package)

(setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
                          ("gnu" . "http://elpa.gnu.org/packages/")
                          ("marmalade" . "http://marmalade-repo.org/packages/")))
  
;; )
;; (package-install 'bookmark+)
(when t
  (add-to-list 'load-path "~/.emacs.d/elpa/bookmark+-20111214")
  (require 'bookmark+))

;; :::::::::::::::::::::::::::::::::::::::::::::::::: KEYS

;; C-x r m		bookmark-set
;; M-s h r		highlight-regex

;; :::::::::::::::::::::::::::::::::::::::::::::::::: PERL
;
;; (defun jm-test-function ()
;;   (interactive)

;; https://github.com/bricoleurs/bricolage/wiki/coding-standards ?

(require 'cperl-mode)
(fset 'perl-mode 'cperl-mode)

(require 'perldoc)

(add-to-list 'auto-mode-alist '("\\.t$" . cperl-mode))

(defun jmc-cperl-mode-hook ()
  ;; SendGrid ~ GNU style with braces aligned with control words
  (cperl-set-style "GNU")
  (setq cperl-continued-brace-offset -2
	indent-tabs-mode nil
        c-basic-offset 2
        cperl-indent-level 2)
  (show-paren-mode 1)
  (local-set-key (kbd "C-h f") 'perldoc-at-point))

(setq cperl-mode-hook 'jmc-cperl-mode-hook)


  ;; (defvaralias 'c-basic-offset 'tab-width)
  ;; (defvaralias 'cperl-indent-level 'tab-width)

;; (make-variable-buffer-local 'tab-width)

;; sudo aptitude install emacs-goodies-el
;; (require 'info-look)
;; (require 'bookmark+)

  ;; (require 'smart-tabs)
  ;; (smart-tabs-advice cperl-indent-line cperl-indent-level)
;; (eval-after-load "compile" '(require 'compilation-perl))

;
;
;; ; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: TWEAKS
;; ;

;; (add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)


(which-function-mode)
(setq use-file-dialog nil)
(tool-bar-mode -1)

;; (server-start t)
;; ;; (desktop-save-mode 1)
;; (setq redisplay-dont-pause t)


;; ;; find-tag is case sensitive for Python
;; ;; (add-hook 'python-mode-hook (lambda () (setq case-fold-search nil)))
;; (setq tags-case-fold-search nil)
;; ;


;; :::::::::::::::::::::::::::::::::::::::::::::::::: MODULES


(when (require 'ido)
  (ido-mode t)
  (setq ido-max-directory-size 10000
        ido-enable-flex-matching t)) ;; enable fuzzy matching


;; :::::::::::::::::::::::::::::::::::::::::::::::::: FLYNOTE


(require 'python)
(when nil
  (load "~/src/flynote/flynote" t))
;;   (message "yay"))


;; ; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: GNUPLOT
;; ;
;; (when (load "gnuplot" t)
;;   (defun jmc-call-gnuplot-on-buffer ()
;;     (interactive)
;;     (save-some-buffers t)
;;     (call-gnuplot-on-buffer))
;;   (add-to-list 'auto-mode-alist '("\\.plt$" . gnuplot-mode))
;;   ;; (define-key gnuplot-mode-map (kbd "C-c C-c") 'jmc-call-gnuplot-on-buffer)
;;   (define-key gnuplot-mode-map (kbd "C-S-<return>") 'jmc-call-gnuplot-on-buffer))
;; ;
;; ; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: EXTERNAL
;; ;
;; ;; (load "~/src/sunlight/jmcompile")
;; ; ;; (load "~/src/rudel/rudel-loaddefs.el" t)

;; ;
;; ; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: KEYS
;; ;

(global-set-key (kbd "C-<return>") 'recompile)
(global-set-key (kbd "C-S-<return>") 'recompile)
(require 'python)
(define-key python-mode-map (kbd "C-<return>") 'flynote-check)
(global-set-key (kbd "C-x g") 'grep)
(global-set-key [f8] 'bury-buffer)
(global-set-key
 (kbd "C-S-<f8>")
 (lambda () (interactive)
   (load "init")))

(global-set-key (kbd "C-x ;") 'comment-region)
(global-set-key (kbd "C-x c") 'compile)


;; :::::::::::::::::::::::::::::::::::::::::::::::::: COMPILATION


(setq compilation-ask-about-save nil)


;; ;; (require 'ipython)
;; ;; (define-key python-mode-map (kbd "C-S-<return>") 'jmc-test-something)
;; ;
;; ;
;; ;
;; ; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: CUSTOM

; ;; :height 120 "this is an integer in units of 1/10 point"
; ;; :width normal
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:background "black" :foreground "white" :height 110)))))


;; ; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: TRAMP
;; ;
(setq tramp-mode nil)
;; ; (setq tramp-mode t
;; ;       tramp-verbose 4)
;; ; ;; (find-file "/dev6-md2.sendgrid.net:work/kamta/Makefile")
;; ;
;; (custom-set-variables
;;   ;; custom-set-variables was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(safe-local-variable-values (quote ((test-case-name . twisted\.mail\.test\.test_smtp) (test-case-name . twisted\.test\.test_process) (test-case-name . twisted\.test\.test_internet\,twisted\.internet\.test\.test_posixbase)))))

;; (server-start)


;; (require 'compile)
;; (setq  compilation-search-path '("." "bin"))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.bmk")
 '(inhibit-startup-screen t))
