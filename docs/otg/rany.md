Rany's _on-the-go_
====================

## How to use it

All you need to do to get setup with Rany's On-the-go is the following (run it in your terminal):

```bash
#!/bin/sh

privkey=$(wg genkey)
pubkey=$(printf %s "$privkey" | wg pubkey)

ret=$(curl -s "-Fpubkey=$pubkey" rany1.duckdns.org:5000)

myaddr=$(printf %s "$ret" | jq -rc .client_address)
serveraddr=$(printf %s "$ret" | jq  -rc .server_address)
serverpubkey="CPOuiTlyE/+C/+3iZOv7XrjPEpwl0MFlbTN4nUrQkRo="

cat <<EOF
[Interface]
PrivateKey = $privkey
Address = $myaddr/8
MTU = 1280

[Peer]
PublicKey = $serverpubkey
AllowedIPs = fd00::/8
Endpoint = $serveraddr
PersistentKeepalive = 25
EOF
```
