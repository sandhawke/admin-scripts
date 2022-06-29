if grep $NEWUSER /etc/passwd; then
    echo "$NEWUSER already in /etc/passwd"
else
    adduser --disabled-password --gecos "$NEWUSER admin" $NEWUSER || exit 1
    mkdir -p /home/$NEWUSER/.ssh || exit 1
    cp /root/.ssh/authorized_keys /home/$NEWUSER/.ssh/authorized_keys || exit 1
    cd /home/$NEWUSER || exit 1
    chown -R $NEWUSER .ssh
    chmod 700 .ssh
    chmod 600 .ssh/authorized_keys
    apt-get -o DPkg::Lock::Timeout=120 install sudo || exit 1
    echo "$NEWUSER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$NEWUSER
fi

