
echo running $0 at $(date)

apt-get update || exit
apt-get upgrade -y || exit

apt-get install -y curl rsync screen build-essential git || exit

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

apt-get -y install certbot nginx || exit 1
certbot certonly --agree-tos --eff-email -t -m $EMAIL -d $HOST --standalone --pre-hook 'service nginx stop' --post-hook 'service nginx start' || exit 1

mkdir -m 755 -p /sites/$HOST
echo "server set up $(date -Ru)" > /sites/$HOST/index.html

# something like 
# echo 'beta:$2y$' > /sites/$HOST/.htpasswd
chmod 644 /sites/$HOST/index.html

cat <<EOF > /etc/nginx/sites-available/default
# redirect all traffic for unexpected hostnames to our primary
server {
	listen 80 default_server;
	listen [::]:80 default_server;
	server_name _;
	return 301 http://$HOST\$request_uri;
}
EOF

CONF=/etc/nginx/sites-available/$HOST
if [ -f $CONF ]; then
    BAK=$CONF-$(date -Is)
    cp $CONF $BAK
fi
sed -e "s/example.com/$HOST/g" < set-me-up.nginx > $CONF
rm -f /etc/nginx/sites-enabled/$HOST
ln -s /etc/nginx/sites-available/$HOST /etc/nginx/sites-enabled/$HOST

nginx -t || exit 1
service nginx restart && echo 'nginx restarted'

# I guess we should take a user name parameter, too  :-)
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

