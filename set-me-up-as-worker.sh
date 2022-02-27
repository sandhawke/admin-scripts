
echo running $0 at $(date)

apt-get update || exit
apt-get upgrade -y || exit

apt-get install -y curl rsync screen build-essential git || exit

# TODO: only allow http when it's on the private interface
apt-get -y install ufw || exit 1
ufw disable
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw default deny incoming
ufw --force enable || exit 1
ufw status verbose || exit 1

echo $HOST

if grep $USER /etc/passwd; then
    echo "$USER already in /etc/passwd"
else
    adduser --disabled-password --gecos "$USER admin" $USER || exit 1
    mkdir -p /home/$USER/.ssh || exit 1
    cp /root/.ssh/authorized_keys /home/$USER/.ssh/authorized_keys || exit 1
    cd /home/$USER || exit 1
    chown -R $USER .ssh
    chmod 700 .ssh
    chmod 600 .ssh/authorized_keys
    apt-get install sudo || exit 1
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER
fi
