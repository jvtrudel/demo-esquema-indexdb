# Prototypo de esquema (JSON schema) editor

This is an exploratory project to allow edition of schemas and
structured data (json schema valid) in a browser.

We'll also explore Progressive Web Application, P2P communication,
collaborative edition using CRDT, webcomponents and any other interesting web technology.


# Usage (Development)

Script `dev` provide useful commands for development purpose:

```
git clone https://github.com/jvtrudel/demo-esquema-indexdb
cd demo-esquema-indexdb
export PATH=$PATH:dev

dev build
dev mkcert
dev run

$BROWSER localhost
```

For mobile development, provide your IP address and open a port on your local network.
For exemple:

```
dev mkcert $IP
dev run

sudo ufw enable
sudo ufw allow in 443/tcp
```

