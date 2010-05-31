; patches for python.el in Emacs23

; JM: allow user functions to be described.
; patch: use "emacs.ehelp(%s, %s)" was "emacs.ehelp(%S, %s)" 
;
; TO USE:
; 1) fire up an inferior Python buffer (C-c C-z)
; 2) send Python defs to it (C-c C-c)
; 3) put cursor on module name or function name
; 4) run python-describe-symbol (C-c C-f)
; 5) help appears in separate *Help* buffer.

; XXX: this is probably wrong, we should patch emacs2.py:ehelp instead.

(defun python-describe-symbol (symbol)
  "Get help on SYMBOL using `help'.
Interactively, prompt for symbol.

Symbol may be anything recognized by the interpreter's `help'
command -- e.g. `CALLS' -- not just variables in scope in the
interpreter.  This only works for Python version 2.2 or newer
since earlier interpreters don't support `help'.

In some cases where this doesn't find documentation, \\[info-lookup-symbol]
will.

PATCHED: SYMBOL can be a local, user-defined function. ~ JM
"
  ;; Note that we do this in the inferior process, not a separate one, to
  ;; ensure the environment is appropriate.
  (interactive
   (let ((symbol (with-syntax-table python-dotty-syntax-table
		   (current-word)))
	 (enable-recursive-minibuffers t))
     (list (read-string (if symbol
			    (format "Describe symbol (default %s): " symbol)
			  "Describe symbol: ")
			nil nil symbol))))
  (if (equal symbol "") (error "No symbol"))
  ;; Ensure we have a suitable help buffer.
  ;; Fixme: Maybe process `Related help topics' a la help xrefs and
  ;; allow C-c C-f in help buffer.
  (let ((temp-buffer-show-hook		; avoid xref stuff
	 (lambda ()
	   (toggle-read-only 1)
	   (setq view-return-to-alist
		 (list (cons (selected-window) help-return-method))))))
    (with-output-to-temp-buffer (help-buffer)
      (with-current-buffer standard-output
 	;; Fixme: Is this actually useful?
	(help-setup-xref (list 'python-describe-symbol symbol) (interactive-p))
	(set (make-local-variable 'comint-redirect-subvert-readonly) t)
	(help-print-return-message))))
  (comint-redirect-send-command-to-process (format "emacs.ehelp(%s, %s)"
						   symbol python-imports)
   "*Help*" (python-proc) nil nil))
