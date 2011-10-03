(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/internet/")


;; :::::::::::::::::::::::::::::::::::::::::::::::::: PACKAGING

(require 'package)
(add-to-list 'package-archives 
	     '("marmalade" . "http://marmalade-repo.org/packages/"))

;; :::::::::::::::::::::::::::::::::::::::::::::::::: KEYS

;; C-x r m		bookmark-set
;; M-s h r		highlight-regex

;; :::::::::::::::::::::::::::::::::::::::::::::::::: PERL
; 
(fset 'perl-mode 'cperl-mode)
(setq
 cperl-close-paren-offset -1
 cperl-continued-statement-offset 0
 cperl-indent-level 2
 cperl-indent-parens-as-block nil
 ;; cperl-tabs-always-indent t)
 )
; 
; 
; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: TWEAKS
; 

(setq redisplay-dont-pause t)
(add-to-list 'auto-mode-alist '("\\.mak$" . makefile-mode))

(which-function-mode)
(setq use-file-dialog nil)
(server-start t)
(tool-bar-mode -1)

;; (desktop-save-mode 1)

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; find-tag is case sensitive for Python
;; (add-hook 'python-mode-hook (lambda () (setq case-fold-search nil)))
(setq tags-case-fold-search nil)
; 
; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: MODULES
; 
(when (require 'ido)
  (ido-mode t)
  (setq ido-max-directory-size 10000
	ido-enable-flex-matching t)) ;; enable fuzzy matching
; 
; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: FLYNOTE
; 
(require 'python)
(when (load "~/src/flynote/flynote" t)
  (message "yay"))
; 
; 
; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: GNUPLOT
; 
(when (load "gnuplot" t)
  (defun jmc-call-gnuplot-on-buffer ()
    (interactive)
    (save-some-buffers t)
    (call-gnuplot-on-buffer))
  (add-to-list 'auto-mode-alist '("\\.plt$" . gnuplot-mode))
  ;; (define-key gnuplot-mode-map (kbd "C-c C-c") 'jmc-call-gnuplot-on-buffer)
  (define-key gnuplot-mode-map (kbd "C-S-<return>") 'jmc-call-gnuplot-on-buffer))
; 
; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: EXTERNAL
; 
;; (load "~/src/sunlight/jmcompile")
; ;; (load "~/src/rudel/rudel-loaddefs.el" t)

; 
; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: KEYS
; 
(global-set-key (kbd "C-x g") 'grep)
(global-set-key [f8] 'bury-buffer)
(global-set-key 
 (kbd "C-S-<f8>")
 (lambda () (interactive)
   (load "init")))

(global-set-key (kbd "C-x ;") 'comment-region)
(global-set-key (kbd "C-x c") 'compile)

(global-set-key 
 [f7] 
 (lambda () (interactive) 
   (find-file "~/.emacs.d/init.el" t)))

(defun jmc-eval-to-here ()
    (interactive)
    (eval-region 0 (point)))
(global-set-key [f9] 'jmc-eval-to-here)


(setq compilation-ask-about-save nil)
(global-set-key (kbd "C-<return>") 'recompile)
(global-set-key (kbd "C-S-<return>") 'recompile)
(require 'python)
(define-key python-mode-map (kbd "C-<return>") 'flynote-check)

;; (require 'ipython)
;; (define-key python-mode-map (kbd "C-S-<return>") 'jmc-test-something)
; 
; 
; 
; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: CUSTOM

; ;; :height 120 "this is an integer in units of 1/10 point"
; ;; :width normal
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:background "black" :foreground "white"
			    :height 140)))))


; ;; :::::::::::::::::::::::::::::::::::::::::::::::::: TRAMP
; 
; (setq tramp-mode t
;       tramp-verbose 4)
; ;; (find-file "/dev6-md2.sendgrid.net:work/kamta/Makefile")
; 
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((test-case-name . twisted\.mail\.test\.test_smtp) (test-case-name . twisted\.test\.test_process) (test-case-name . twisted\.test\.test_internet\,twisted\.internet\.test\.test_posixbase)))))

(server-start)


(require 'compile)
(setq  compilation-search-path '("." "bin"))


