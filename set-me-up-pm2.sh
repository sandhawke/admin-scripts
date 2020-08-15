# runs as user who will run node-process, not root, but needs sudo for this

# can be undone for re-setup by just: rm -rf /home/sandro/.nvm

# What node version do we want pm2 running under?
VERSION=14.8.0 

if ! node --version; then 

    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash
    # make nvm active now
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    
    # we do these as us, NOT SUDO
    # do we want --lts on both of these?
    nvm install $VERSION
    nvm use $VERSION
fi

npm i -g pm2

# this is what pm2 says to do
#  
sudo env PATH=$PATH:$HOME/.nvm/versions/node/v$VERSION/bin $HOME/.nvm/versions/node/v$VERSION/lib/node_modules/pm2/bin/pm2 startup systemd -u `whoami` --hp $HOME

pm2 startup
