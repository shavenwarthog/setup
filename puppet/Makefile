all:

test:
	find -name '*.pp' | xargs -n 1 -t puppet --parseonly
apply:
	puppet apply  --debug */site.pp
#	puppet apply --debug --modulepath=manifests/modules */site.pp

