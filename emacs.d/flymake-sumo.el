;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FLYMAKE/SUMO

(require 'flymake)

(defvar flymake-sumo-command "sumosync"
  "Shell command to run to check Emacs buffer.")


(defun flymake-sumo-init ()
  "Call 'sumosync'"

  ; abort if current directory not writable. Otherwise, "create-copy"
  ; will fail
  (if (file-writable-p ".")
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
			 'flymake-create-temp-inplace))
	     (local-file (file-relative-name
			  temp-file
			  (file-name-directory buffer-file-name))))
	(list flymake-sumo-command (list local-file)))))

(add-to-list 'flymake-allowed-file-name-masks
	     '("\\.py\\'" flymake-sumo-init))

(add-hook 'find-file-hook 'flymake-find-file-hook)

;;  pylint -f parseable ~/z.py | head
;; No config file found, using default configuration
;; /home/johnm/z.py:1: [C] Missing docstring
;; /home/johnm/z.py:2: [E] Undefined variable 'os'
;; /home/johnm/z.py:3: [W] Statement seems to have no effect

; regexp file-idx line-idx col-idx (optional) text-idx(optional), 
; match-end to end of string is error text

(add-to-list 
 'flymake-err-line-patterns 
 ;; Python  X: all msgs are errors
 '("\\(.*\\):\\([0-9]+\\): \\(.+\\)" 1 2 nil 3)
)

(provide 'flymake-sumo)


