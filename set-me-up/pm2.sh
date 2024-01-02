# runs fine as non-root

# can be undone for re-setup by just: rm -rf $USER/.nvm

# What node version do we want pm2 running under?
VERSION=16.15.0
echo target version $VERSION

if ! node --version; then 

    curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    # make nvm active now
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    
    # we do these as us, NOT SUDO
    # do we want --lts on both of these?
    nvm install $VERSION
    nvm use $VERSION

    # Bit of a hack. The default .bashrc on debian11 (at least) bails
    # out about 5 lines in if it's a non-interactive shell. This means when
    # we execute a command via ssh, nvm isn't available.  So let's fix that.
    # Because... blinding editing .bashrc is the bomb.
    sed -i '1i\ \n# Load NVM even when non-interactive\nexport NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"\n' $HOME/.bashrc
    
    echo '=== nvm in use'
fi

npm i -g pm2

# this is what pm2 says to do
#  
sudo env PATH=$PATH:$HOME/.nvm/versions/node/v$VERSION/bin $HOME/.nvm/versions/node/v$VERSION/lib/node_modules/pm2/bin/pm2 startup systemd -u `whoami` --hp $HOME

echo '=== starting pm2'

pm2 startup

echo '=== pm2 started'
