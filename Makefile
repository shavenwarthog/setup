all:

.PHONY: elispref.tags
elispref.tags:
	ctags-exuberant -e -f elispref.tags \
	--langdef=elispref \
	--langmap=elispref:.html 	\
	--regex-elispref='/(Command|Form|Function): <b>(.+?)<.b>/\2/f,function/' \
	~/Documents/elisp.html
	@head $@

install:
	-ln -s $(PWD)/emacs.d ~/.emacs.d
	-ln -s $(PWD)/bash_aliases ~/.bash_aliases
	-ln -s $(PWD)/bashrc ~/.bashrc
# -ln -s $(PWD)/licrc ~/.licrc
# -ln -s $(PWD)/bin ~/bin



