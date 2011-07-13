
;; :::::::::::::::::::::::::::::::::::::::::::::::::: TAGS

;; M-.  find tag under cursor, where tag is a *symbol*
;; M-,  find next matching *symbol*
;;

(setq tags-revert-without-query t
      tags-case-fold-search nil)

;; (tags-search "^def search(")
;; (tags-apropos "search")
(global-set-key (kbd "M-?") 'tags-apropos)

(defun tag-py-outer-match-p (tag)
  "Return non-nil if TAG defined at outer level of Python source;
class or function."
  (tag-re-match-p (format "^def %s(" tag)))

(defun jmc-set-match-order ()
  (interactive)
  (setq find-tag-tag-order .
	(;; tag-py-outer-match-p
	 ;; tag-exact-file-name-match-p
	 ; tag-file-name-match-p
	 ;; tag-exact-match-p
	 ;; tag-implicit-name-match-p
	 'tag-symbol-match-p
	 ;; tag-word-match-p
	 ;; tag-partial-file-name-match-p
	 ;; tag-any-match-p
	 )))

;; find-tag-tag-order is a variable defined in `etags.el'.
;; (tag-exact-file-name-match-p tag-file-name-match-p
;; tag-exact-match-p tag-implicit-name-match-p tag-symbol-match-p
;; tag-word-match-p tag-partial-file-name-match-p tag-any-match-p)

(provide 'jmtags)
