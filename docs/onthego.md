CRXN _on-the-go_
================

## What is this?

Deavmi runs a Wireguard tunneling service for client-only (meaning you won't route other's traffic) access to CRXN.

The service is made available over the following networks:

* Clearnet IPv6 (_Coming soon_)
	* This means you can connect your Wireguard endpoint to an IPV6 host (my server)
	* Endpoint address: `2a04:5b81:2010::65`
* Yggdrasil
	* This means you can run the [Yggdrasil software](http://yggdrasil-network.github.io) and use an Yggdrasil IPv6 address as the Wireguard endpoint
	* Endpoint address: `301:754:2ca2:57f8::1`

## Setup procedure

### Generate the private key

You need to generate a private-public key pair for your Wireguard instance.

```
wg genkey | sudo tee /etc/systemd/network/crxn0-private.key
chmod 600 /etc/systemd/network/crxn0-private.key
```

### Fetch the public key

Get the public key from it (you will need to send that to deavmi):

```
sudo cat /etc/systemd/network/crxn0-private.key | wg pubkey
```

You can then send this to `deavmi` on [BNET](/projects/bonobonet) in the `#crxn` channel. You can also shoot him an email via `deavmi@redxen.eu`.

### Configure a new wireguard device

```
sudo cat > /etc/systemd/network/crxn0.netdev <<EOF
[NetDev]
Name = crxn0
Kind = wireguard
Description = wg peering with crxn over yggdrasil

[WireGuard]
PrivateKeyFile = /etc/systemd/network/crxn0-private.key
ListenPort = 51820

[WireGuardPeer]
PublicKey = e0zNJwCyP+sD5oiF0QAkzrM3rJpmg1NeGxEHVCfBClM=
AllowedIPs = fd00::/8

# Depending on how you want to connect change the endpoint here (port remains constant)
Endpoint = [301:754:2ca2:57f8::1]:51820
EOF
```

### Create the crxn network configuration file

```
sudo cat > /etc/systemd/network/20-crxn0.network <<EOF
[Match]
Name=crxn0

[Network]
IPv6AcceptRA=false

[Address]
## Uncomment and change this to your IP address
# Address=fdf1:1dc1:f54d:0001::1/64 # CHANGE THIS !!!!
## Uncomment to route packets from another interface, ie eth0
# AddPrefixRoute=false

[Route]
Destination=fd00::/8
EOF
```

### Restart

Restart the service to apply all changes

```
sudo systemctl restart systemd-networkd
```
