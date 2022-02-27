apt-get update || exit
apt-get upgrade -y || exit
apt-get install -y curl rsync screen build-essential git || exit

sh ssh-only.sh
