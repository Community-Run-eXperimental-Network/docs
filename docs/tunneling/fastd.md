Fastd tunneling
===============

This document will help you get peered over a layer-2 VPN using `fastd`.

## Installing dependencies

This document assumes that you are using a Linux system (as one should) and a systemd-based system, the latter part is not really a requirement but it just for having things start on system startup.

The following need to be installed:

1. `fastd`
	* This is the layer 2 tunnelling daemon we use to link up machines essentially providing a virtual ethernet network between the two nodes we want to link.
2. Optional: `yggdrasil`, `cjdns`
	* These are both overlay networks that can be used if clear-net access is not possible.
	* We recommend you still use them as they can run without internet access too and redundancy is a goal of CRXN and having a diverse peering setup

## Setting up a tunnel

The next step is to setup a tunnel. You will have to contact someone to get the following:

1. `ip:port` pairing details
	* The endpoint of their *fastd* instance
2. `public key`
	* You will need their public key which will be used to secure the connection to them such that traffic is encrypted (CRXN traffic and babeld router messages)

Create a file with the template and instructions below in `/etc/fastd/crxn/fastd.conf`:

```
# The interface that will connect to the virtual ethernet network fastd connects us to
interface "crxn%n";
mode multitap;

# The encryption method (don't change this unless you need to)
method "salsa2012+umac";

# Bind to and listen for incoming connections on this address and port
bind <ip>:<port>;

# Secret key (you generate this)
secret "<secret key>";

# Setup a peer to allow incoming connections from or initiate a connection too
peer "<peerName>"
{
    remote <type> "<ip>" port <port>;
    key "<peer's public key>";
}

```

If your system uses ifconfig append
```
# On interface rise run
on up "ifconfig $INTERFACE up";
on down "ifconfig $INTERFACE down";
```

If your system uses ip append
```
on up "ip link set dev $INTERFACE up";
on down "ip link set dev $INTERFACE down";
```

The template needs to have the following filled in:

1. `<ip>` and `<port>`
	* The IP address and port to bind to and listen on for incoming connections from your peer's daemon (if his daemon initiates the connection first)

Now you must run the following:

```
fastd --generate-key
```

Then save the *public key* and the *private key*. **Note:** You must give your peer your *public key*.

2. `"<secret key>"`
	* This must be the *private key* you generated earlier


Now we need to fill in the peer details of the node you are connecting to:

1. `"<peerName>"`
	* Sets the interface name of the connection with the peer to crxn`<peerName>`
2. `<type>`
	* Set this to either `ipv4` or `ipv6` depending of the address being used to connect to the remote peer
3. `"<ip>"`
	* Set this to the remote peer's fastd address
4. `"port`
	* Set this to the remote peer's fastd port
5. `"<peer's public key>"`
	* Set this to your peer's public key

The last thing to configure now is to rise the interface up when fastd starts (as it normally doesn't rise it for you), all occurences of `<interfaceName>` here should match the one in the `interface <interfaceName>;` declaration as shown earlier.

### Starting and maintaining the daemon

You can then start the daemon as follows:

```
sudo fastd -c /etc/fastd/crxn/fastd.conf
```

### Systemd unit

Fastd can also be set up with systemd units.

Run `systemctl start fastd@crxn` to bring up the tunnel
Run `systemctl stop fastd@crxn` to bring down the tunnel

To enable the systemd unit on startup run `systemctl enable fastd@crxn`
