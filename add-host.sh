#!/bin/sh

HOST=$1

if [ -z "$HOST" ]; then
    echo "usage: $0 <hostname>"
    exit 1
fi

if [ -z "$EMAIL" ]; then
    echo "usage: EMAIL=<email> $0 <hostname>"
    exit 1
fi

echo running $0 $HOST at $(date)

if [ -d /etc/letsencrypt/live/$HOST ]; then
    echo Certbot already run for $HOST
else
    certbot certonly --nginx --agree-tos --eff-email -t -m $EMAIL -d $HOST || exit 1
fi

mkdir -m 755 -p /sites/$HOST
echo "server set up $(date -Ru)" > /sites/$HOST/index.html
chmod 644 /sites/$HOST/index.html

CONF=/etc/nginx/sites-available/$HOST
if [ -f $CONF ]; then
    BAK=$CONF-$(date -Is)
    cp $CONF $BAK
fi
sed -e "s/example.com/$HOST/g" < set-me-up-static.nginx > $CONF
rm -f /etc/nginx/sites-enabled/$HOST
ln -s /etc/nginx/sites-available/$HOST /etc/nginx/sites-enabled/$HOST

nginx -t || exit 1

service nginx reload && echo 'nginx reloaded'
