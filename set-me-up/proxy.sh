echo 'DONT USE THIS.  User configure-server-app instead'
exit 1

CONF=/etc/nginx/sites-available/$HOST
if [ -f $CONF ]; then
    BAK=$CONF-$(date -Is)
    cp $CONF $BAK

    sed -e "s/example.com/$HOST/g" < proxy.nginx > $CONF
else
    echo Set up static first, please
    exit
fi

nginx -t || exit 1
service nginx reload && echo 'nginx reloaded'
