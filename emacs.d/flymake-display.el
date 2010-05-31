;;http://www.credmp.org/2007/07/20/on-the-fly-syntax-checking-java-in-emacs/

(defun credmp/flymake-display-err-minibuf ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-no (flymake-current-line-no))
	 (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
	 (count (length line-err-info-list))
	 )
    (while (> count 0)
      (when line-err-info-list
	(let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
	       (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
	       (text (flymake-ler-text (nth (1- count) line-err-info-list)))
	       (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
	  (message "[%s] %s" line text)
	  )
	)
      (setq count (1- count)))))



(setq fd-err-info '((56
  ([cl-struct-flymake-ler nil 56 "e" "[E] Undefined variable 'main'" "~/src/cooljob/cjob.py"]))
 (65
  ([cl-struct-flymake-ler nil 65 "e" "[E, update] Undefined variable 'subprocess'" "~/src/cooljob/cjob.py"]))
 (67
  ([cl-struct-flymake-ler nil 67 "e" "[E, update] Undefined variable 'subprocess'" "~/src/cooljob/cjob.py"]))))
(dolist (item  56 (car fd-err-info))
(defun jmc-current-error ()
  (interactive)
  (

(defun note (msg)
  (message msg)
  (sleep-for 1))


(defun jmc-beer ()
  (interactive)
  (message "%s" (jmc-current-error)))
(global-set-key [kp-delete] 'jmc-beer)

