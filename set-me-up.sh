
echo running $0 at $(date)

apt-get update || exit
apt-get upgrade -y || exit

apt-get install -y curl rsync screen build-essential checkinstall git || exit

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

adduser --disabled-password --gecos 'Sandro Hawke' sandro
mkdir -p ~sandro/.ssh
cp /root/.ssh/authorized_keys ~sandro/.ssh/authorized_keys
cd ~sandro
chown -R sandro .ssh
chmod 700 .ssh
chmod 600 .ssh/authorized_keys
apt-get install sudo
echo 'sandro ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/sandro

