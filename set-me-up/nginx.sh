
mkdir -m 755 -p /sites/$HOST
echo "server set up $(date -Ru)" > /sites/$HOST/index.html

# something like 
# echo 'beta:$2y$' > /sites/$HOST/.htpasswd
chmod 644 /sites/$HOST/index.html

if [ ! -f /etc/nginx/sites-available/default ]; then
    cat <<EOF > /etc/nginx/sites-available/default
# redirect all traffic for unexpected hostnames to one of ours
server {
	listen 80 default_server;
	listen [::]:80 default_server;
	server_name _;
	return 301 http://$HOST\$request_uri;
}
EOF
fi

CONF=/etc/nginx/sites-available/$HOST
if [ -f $CONF ]; then
    BAK=$CONF-$(date -Is)
    cp $CONF $BAK
fi
sed -e "s/example.com/$HOST/g" < static.nginx > $CONF
rm -f /etc/nginx/sites-enabled/$HOST
ln -s /etc/nginx/sites-available/$HOST /etc/nginx/sites-enabled/$HOST

nginx -t || exit 1
service nginx reload && echo 'nginx reloaded'
