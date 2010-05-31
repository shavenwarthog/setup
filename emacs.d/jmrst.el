;; (defvar jmrst-slides-program "firefox"
;;   "Program used to preview S5 slides.")

(defun msg-me (process event)
  (princ
   (format "Process: %s had the event `%s'" process event)))

(defun jmrst-compile-slides-preview-sentinel (process event)
  (jmc-reload-browser))

(defun jmrst-compile-slides-preview ()
  "Convert the document to an S5 slide presentation and launch a preview program."
  (interactive)
  (let* ((tmp-filename "/tmp/slides.html")
         (command (format "rst2s5 %s %s"
                          buffer-file-name tmp-filename))
	 (proc (start-process-shell-command 
		"jmrst-slides-preview" nil command)))
    (set-process-sentinel proc 'jmrst-compile-slides-preview-sentinel)
    ;; Note: you could also use (compile command) to view the compilation
    ;; output.
    ))


