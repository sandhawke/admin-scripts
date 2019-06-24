# runs as user who will run node-process, not root, but needs sudo for this

if ! node --version; then 

    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
    # make nvm active now
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    
    # we do these as us, NOT SUDO
    nvm install --lts
    nvm use --lts
fi

npm i -g pm2

# this is what pm2 says to do
#  
sudo env PATH=$PATH:$HOME/.nvm/versions/node/v10.16.0/bin $HOME/.nvm/versions/node/v10.16.0/lib/node_modules/pm2/bin/pm2 startup systemd -u `whoami` --hp $HOME

pm2 startup
