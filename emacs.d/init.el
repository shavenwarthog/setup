(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/internet/")


;; :::::::::::::::::::::::::::::::::::::::::::::::::: TWEAKS

;; (desktop-save-mode 1)

(require 'python)
(add-to-list 'auto-mode-alist '("\\.tac$" . python-mode))

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; find-tag is case sensitive for Python
;; (add-hook 'python-mode-hook (lambda () (setq case-fold-search nil)))
(setq tags-case-fold-search nil)

;; :::::::::::::::::::::::::::::::::::::::::::::::::: MODULES

(when (require 'ido)
  (ido-mode t)
  (setq ido-max-directory-size 1000000)
  (setq ido-enable-flex-matching t)) ;; enable fuzzy matching

;; :::::::::::::::::::::::::::::::::::::::::::::::::: FLYNOTE

(require 'python)
(when (load "~/src/flynote/flynote" t)
  (add-to-list 'flynote-load-path "~/src/flynote") ; XX
  (add-hook 'python-mode-hook
	    (lambda ()
	      (flynote-mode)
	      (flynote-set-pylint))))

(define-key python-mode-map (kbd "C-<return>") 'flynote-check)

;; :::::::::::::::::::::::::::::::::::::::::::::::::: GNUPLOT

(when (load "gnuplot" t)
  (defun jmc-call-gnuplot-on-buffer ()
    (interactive)
    (save-some-buffers t)
    (call-gnuplot-on-buffer))
  (add-to-list 'auto-mode-alist '("\\.plt$" . gnuplot-mode))
  ;; (define-key gnuplot-mode-map (kbd "C-c C-c") 'jmc-call-gnuplot-on-buffer)
  (define-key gnuplot-mode-map (kbd "C-S-<return>") 'jmc-call-gnuplot-on-buffer))

;; :::::::::::::::::::::::::::::::::::::::::::::::::: EXTERNAL

(load "~/src/sunlight/jmcompile")
(load "~/src/rudel/rudel-loaddefs.el" t)

;; :::::::::::::::::::::::::::::::::::::::::::::::::: KEYS

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


(global-set-key (kbd "C-<return>") 'jmc-make-recompile)
(define-key python-mode-map (kbd "C-S-<return>") 'jmc-test-something)



;; :::::::::::::::::::::::::::::::::::::::::::::::::: CUSTOM

;; elpowers:
;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(default ((t (:background "black" :foreground "white" :weight normal :family "DejaVu Sans Mono"
;; 			    :height 120)))))
;; :height 120 "this is an integer in units of 1/10 point"
;; :width normal
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:background "black" :foreground "white")))))
;;			    :height 120)))))

;;  :weight normal :family "DejaVu Sans Mono"
;; ? (setq scalable-fonts-allowed t)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((test-case-name . twisted\.mail\.test\.test_mail) (test-case-name . twisted\.mail\.test\.test_smtp)))))
