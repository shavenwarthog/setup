; http://trac.codecheck.in/share/browser/dotfiles/emacs/k1low/.emacs.d/conf/init-flymake.el?rev=1234

;;; emacs lisp
(defun flymake-elisp-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "elisplint" (list local-file))))
(push '("\\.el$" flymake-elisp-init) flymake-allowed-file-name-masks)

(add-hook 'emacs-lisp-mode-hook 'flymake-mode)

