all:

.PHONY: *.html
%.html:	%.el
	enscript -whtml -o$@ -t'$<' -Eelisp --fancy-header --color $<
