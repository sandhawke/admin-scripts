ufw allow http
ufw allow https

apt-get -o DPkg::Lock::Timeout=120 -y install python3-certbot-nginx

while ! certbot certonly --nginx --agree-tos --eff-email -t -m $EMAIL -d $HOST
do
    echo certbot failed, lets sleep 90s and try again
    sleep 90
done
