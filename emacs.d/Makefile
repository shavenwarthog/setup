all:

.PHONY: *.html
%.html:	%.el
	enscript -whtml -o$@ -t'$<' -Eelisp --fancy-header --color $<

tags:
	ctags-exuberant -e --recurse --languages=lisp . ~/src/sunlight ~/src/flynote
