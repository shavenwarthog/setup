(defun jmc-enable-iimage (compilation-buffer msg)
  (with-current-buffer compilation-buffer
    (iimage-mode 1)))

(when nil
  (add-hook 'compilation-finish-functions 'jmc-enable-iimage))

;; /remotehost:filename
(setq tramp-default-method "ssh")

(provide 'sendgrid)
