all:


.PHONY: lisp
lisp:
	./format.py /usr/share/emacs/23.3/lisp/*.el.gz


.PHONY: el-index.html
el-index.html:
	./mkindex.py /usr/share/emacs/23.3/lisp/*.el.gz \
	| cat > $@


