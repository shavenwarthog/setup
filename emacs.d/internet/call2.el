(defun simple-call-tree-list-functions-and-callers ()
  "List functions and callers in `simple-call-tree-alist'."
  (interactive)
  (let ((list (simple-call-tree-invert simple-call-tree-alist)))
    (switch-to-buffer (get-buffer-create "*simple-call-tree*"))
    (erase-buffer)
    (dolist (entry list)
      (let ((callers (mapconcat #'identity (cdr entry) ", ")))
	(insert (car entry) " is called by "
		(if (string= callers "")
		    "no functions."
		  callers)
		".\n")))))

;; Alternatively, if you wanted to list which callers and the
;; functions they call, you could use something like:

(defun simple-call-tree-list-callers-and-functions ()
  "List callers and functions in `simple-call-tree-alist'."
  (interactive)
  (let ((list simple-call-tree-alist))
        (switch-to-buffer (get-buffer-create "*simple-call-tree*"))
        (erase-buffer)
        (dolist (entry list)
          (let ((functions (mapconcat #'identity (cdr entry) ", ")))
            (insert (car entry) " calls "
                    (if (string= functions "")
                        "no functions"
                        functions)
                    ".\n")))))
