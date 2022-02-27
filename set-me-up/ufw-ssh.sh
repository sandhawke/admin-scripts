apt-get -y install ufw || exit 1
ufw disable
ufw default allow outgoing
ufw allow ssh
ufw default deny incoming
ufw --force enable || exit 1
ufw status verbose || exit 1
