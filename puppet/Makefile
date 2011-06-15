all:

test:
	find -name '*.pp' | xargs -n 1 -t puppet --parseonly

# X: actually "sudo make apply"
apply:
	puppet apply --verbose */site.pp
debug:
	puppet apply  --debug */site.pp
#	puppet apply --debug --modulepath=manifests/modules */site.pp

