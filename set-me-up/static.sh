export DEBIAN_FRONTEND=noninteractive

echo "## static.sh running HOST=$HOST EMAIL=$EMAIL"

apt-get -o DPkg::Lock::Timeout=120 install -y nginx || exit 1

sh certbot.sh || exit 1
sh nginx.sh || exit 1
