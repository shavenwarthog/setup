install:
	-ln -s $(PWD)/emacs.d ~/.emacs.d
	-ln -s $(PWD)/bash_aliases ~/.bash_aliases
	-ln -s $(PWD)/bashrc ~/.bashrc
	-ln -s $(PWD)/licrc ~/.licrc
	-ln -s $(PWD)/bin ~/bin
	-ln -s $(PWD)/xmonad ~/.xmonad
	-mv ~/.wmii-3.5 ~/.wmii-OLD
	-ln -s $(PWD)/wmii ~/.wmii-3.5



