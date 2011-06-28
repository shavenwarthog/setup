(add-to-list 'load-path "~/.emacs.d/")

;; :::::::::::::::::::::::::::::::::::::::::::::::::: TWEAKS
(desktop-save-mode 1)

;; :::::::::::::::::::::::::::::::::::::::::::::::::: MODULES

(when (require 'ido)
  (ido-mode t)
  (setq ido-enable-flex-matching t)) ;; enable fuzzy matching

;; :::::::::::::::::::::::::::::::::::::::::::::::::: KEYS

(global-set-key [f7] (lambda () (interactive) 
		       (find-file "~/.emacs.d/init.el" t)))
(global-set-key (kbd "C-x ;") 'comment-region)
(global-set-key (kbd "C-x c") 'compile)


;; :::::::::::::::::::::::::::::::::::::::::::::::::: CUSTOM

;; elpowers:
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))
