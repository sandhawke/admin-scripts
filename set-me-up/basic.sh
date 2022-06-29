apt-get -o DPkg::Lock::Timeout=120 update || exit
apt-get -o DPkg::Lock::Timeout=120 upgrade -y || exit
apt-get -o DPkg::Lock::Timeout=120 install -y curl rsync screen build-essential git inotify-tools || exit

sh ufw-ssh.sh
