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

Once we have this information we can begin the setup with the below as the template:

```
# The interface that will connect to the virtual ethernet network fastd connects us to
interface "<interfaceName>";

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

# On interface rise run
on up "ifconfig <interfaceName> up";
```

So the above needs to have the following filled in:

1. `"<interfaceName>"`
	* This is of your choosing and will need to be remembered for later steps
2. `<ip>` and `<port>`
	* The IP address and port to bind to and listen on for incoming connections from your peer's daemon (if his daemon initiates the connection first)

Now you must run the following:

```
fastd --generate-key
```

Then save the *public key* and the *private key*. **Note:** You must give your peer your *public key*.

3. `"<secret key>"`
	* This must be the *private key* you generated earlier


Now we need to fill in the peer details of the node you are connecting to:

1. `"<peerName>"`
	* Set this to the name of the peer (can be anything really)
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
sudo fastd -c /etc/fastd/path/to/config.conf
```

**TODO: Sosytemd-unit**