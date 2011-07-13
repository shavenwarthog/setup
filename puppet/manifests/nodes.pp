# /etc/puppet/manifests/nodes.pp

node basenode {
  package {
    ["apache2", "curl", 'git', 'emacs',
     'gnuplot', 'evince', 'fortunes-off',
     'sshfs', 'pylint', 'man2html',
     'python-nose', 'python-pip', 'python-dev',
'libzmq-dev',
'pymacs',
'pyflakes',
'exuberant-ctags',

     'vim',
     ]:
      ensure => installed;
  }
  # package { "emacs":
  #   ensure => "installed"
  # }
  #   include sudo
}

node 'shoemitten' inherits basenode {
}

