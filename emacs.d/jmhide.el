;; ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

(load "emacswikisrc/hide-region")

(defun jm-hide-pattern (pattern)
  (set-mark (point))
  (let ((endpos (re-search-forward pattern nil t)))
    (if endpos
	(hide-region-hide))))

(while (re-search-forward "foo[ \t]+bar" nil t)
       (replace-match "foobar"))

(defun jm-hide-match (pattern)
  (when (re-search-forward pattern nil t)
    (set-mark (match-beginning 0))
    (hide-region-hide)))

(defun jm-hide-match2 (startpat endpat)
  (when (re-search-forward startpat nil t)
    (set-mark (match-beginning 0))
    (when (re-search-forward endpat nil t)
      (goto-char (match-beginning 0))
      (hide-region-hide))))

(defun jm-hide-to (endpat)
  (set-mark (point))
  (when (re-search-forward endpat nil t)
    (hide-region-hide)))

(defun jm-delete-all (pat)
  (goto-char (point-min))
  (while (re-search-forward pat nil t)
    (replace-match "")))

(defun jm-find-traceback ()
  (goto-char (point-min))
  (when (re-search-forward "^Traceback.+\n" nil t)
    (hide-region-hide)))
  ;; (jm-delete-all "^Compilation.+\n")
(defun zoot () 
  (interactive)
  (goto-char (point-min))
  (while (re-search-forward pat nil t)
  ;; (jm-hide-to "===*$")		; header
  ;; (jm-hide-match "^--+$")
  ;; (jm-hide-match2 "^Traceback" "^[A-Z]")
  (jm-hide-match "^Compilation.+")
  )
(global-set-key [kp-multiply] 'zoot)
(global-set-key [S-kp-multiply] 'hide-region-unhide)
