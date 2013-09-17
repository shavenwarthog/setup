'''
fabfile.py -- package install and setup for John's lappytop
'''

from fabric.api import execute, env, task
from fabric.operations import local, run, sudo


def agi(packages):
    return sudo('apt-get install --yes {}'.format(packages))


@task
def install_handbrake():
    sudo('add-apt-repository ppa:stebbins/handbrake-releases')
    sudo('apt-get update')
    sudo('apt-get install handbrake-gtk')


@task
def install_base():
    """
    everyday developer tools
    """
    agi('chromium-browser emacs24 exuberant-ctags'
        ' git git-flow pylint python-pip vim'
        )
    sudo('pip install virtualenvwrapper')


@task
def install_extra():
    """
    tools every day or two
    """
    agi('man2html skype')


@task
def install_goodies():
    """
    music and video players
    """
    execute(install_handbrake)


# ::::::::::::::::::::::::::::::::::::::::::::::::::

# TODO: "16 things configure on any new server"
# http://www.electricmonk.nl/log/2013/08/29/16-things-you-should-absolutely-configure-on-any-new-server/

# XXX: this is a note more than anything else
@task
def setup_fabric():
    # TODO: /etc/sudoers.d/fabric?
    local('sudo echo "{0} ALL = NOPASSWD: ALL" >> /etc/sudoers'.format(
            env.user))
    agi('openssh-server')

@task
def setup_16things():
    pass
# 1. Pick a good hostname
# 2. Put all hostnames in /etc/hosts
# 3. Install ntpd
# 4. Make sure email can be delivered
# 5. Cron email
# 6. Protect the SSH port
# 7. Configure a firewall
# 8. Monitor your system
# 9. Configure resource usage
# 10. Keep your software up-to-date
# 11. Log rotation
# 12. Prevent users from adding SSH keys
# 13. Limit user crontabs
# 14. Backups, backups and more backups
# 15. Install basic tools
# 16. Install fail2ban


@task
def test_lsudo():
    sudo('id')

