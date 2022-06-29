export DEBIAN_FRONTEND=noninteractive

echo '=== basic'
sh basic.sh || exit

echo '=== pm2'
sh pm2.sh || exit

echo '=== user'
if [ ! -z "$NEWUSER" ]; then
    echo '(really user)'
    sh with-user.sh || exit
else
    echo 'no value for NEWUSER'
fi

echo '=== static'
sh static.sh || exit

exit 0
