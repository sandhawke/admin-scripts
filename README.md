# admin-scripts

Shell scripts I use, mostly which I wrote myself

These are ***NOT SAFE*** for other people to use directly.  They
hardcode things like my email address and linux version assumptions.

## Server admin stuff (home-grown mini-ansible)


### configure-server [host]

Given a fresh debian host, set it up with my nginx server
environment. The bulk of the work is done by set-me-up.sh running on
the server.

* host defaults to $TARGET
* hardcodes admin email address
* Makes a sudo-er account on the server with the same username

### configure-server-pm2 [host]

Set up the server for running node-based apps.  Installs node **via
[nvm](https://github.com/nvm-sh/nvm)** and installs
[pm2](https://pm2.keymetrics.io/) to keep a node up running.

Hardcodes the version of node.js that pm2 will be running.

* host defaults to $TARGET

### `LOCATION=/v2.1/ PORT=3002 TARGET=example.com` configure-server-app

(This is run for you by push-to-server if you have a run.js)

Add adds the nginx proxy_pass line so that URL ends up on that
port.

Should be when deploying a new app or new app version for the first time.

### push-to-server {prod}

(Probably too much hard coding for me these days.)

Figures out a PORT, VERSION, LOCATION from the version in
package.json, unless "prod" flag is given, in which case PORT=3000 and
LOCATION=/

Uses .push-to-server setting variables as configuration

If there's a file called "run.js" it sets up a server environment (npm
i) in /proxy_pass/$PORT

### auto-push-to-server

Runs push-to-server whenever any files change.

