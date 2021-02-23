# Tutorial

This document will help you get connected to the CRXN IPv4-IPv6 inter-network.

## Installing dependencies

This document assumes that you are using a Linux system (as one should) and a systemd-based system, the latter part is not really a requirement but it just for having things start on system startup.

The following need to be installed:

1. `fastd`
	* This is the layer 2 tunnelling daemon we use to link up machines essentially providing a virtual ethernet network between the two nodes we want to link.
2. `babeld`
	* This is the dynamic mesh routing daemon. Dynamic in the sense it adds and distributes routes for us such that we don't have to do it by hand (i.e. static routing) and mesh in the sense the routing daemons automatically discover each other
3. Optional: `yggdrasil`, `cjdns`
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
on up "
ifconfig <interfaceName> up
ifconfig <interfaceName> <ip>/32
";
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

The next thing to fill in is `<ip>` - the reason for this is two fold, babel will only run if an interface has an IP assigned to the interface it is running on (it uses this as the next-hop to distribute to remote routers). The second is because we want packets destined to this router (as a host) to be accepted and on Linux that means the destination IP in the packet must match an IP address assigned to any interface, assigning it to this one will do - as they say

*Hitting two birds with one stone (no pun intended, don't kill your routing daemon twice)*

### Starting and maintaining the daemon

You can then start the daemon as follows:

```
sudo fastd -c /etc/fastd/path/to/config.conf
```

**TODO: Sosytemd-unit**

---

## Configuring the routing daemon

Babeld will allow your machine to distribute subnets it has directly attached as well as remote ones it has learnt from other babeld nodes - to other babeld nodes on it is directly linked to. This helps build up its routing table to know where to forward packets to (forwarding will be enabled on all interfaces when babeld runs, and disabled when it stops).

You will want to add the following lines to your `/etc/babeld.conf`:

```
# Redistribute all CRXN (10/8) routes
redistribute ip 10.0.0.0/8 ge 8

# Only learn routes in the CRXN (10/8) range
in ip 10.0.0.0/8 ge 8 allow

# Redistribute all CRXN (IPv6 - fd8a:6111:3b1a::/48)
redistribute ip fd8a:6111:3b1a::/48 ge 48

# Only learn routes in the CRXN (fd8a:6111:3b1a::/48) range
in ip fd8a:6111:3b1a::/48 ge 48 allow
```

This will redistribute routes from your kernel's routing table that match the subnets described (CRXN IPv4 `10/8` and IPv6 `fd00::/8`) into babel's internal routing table which will then be exported to neighbouring babel routers. Babel will learn any routes that are distributed into it (**TODO**: We could filter here too, with `in`).

The next line you will add is to not redistribute your own host address as a route (because a subnet being redistributed would catch that), therefore add the following line:

```
redistribute local deny
```

Idk if this makes shit more statistically acuurate for link quality, but I enabled it:
**TODO** I mean it is not needed

```
diversity true
```

Now run babeld on the interface we just setup via the *fastd* tunnel (this is where that `<interfaceName>` will be used:

```
# Send and receive router updates only on <interfaceName>
# Babel will enable forwarding on all interfaces (and disable on exit)
interface <interfaceName> enable-timestamps true link-quality true
```

The `enable-timestamps` enables transferring of timestamps in messagessuch that an RTT (round-trip time) can be calculated for the babel messages

**TODO:** I guess link quality was to check quality

### Starting and maintaining the daemon

You can then start the daemon as follows:

```
sudo babeld -g 33123 -c /etc/babeld.conf
```

**TODO: Sosytemd-unit**

---

## Configuring the subnet

Your router is now on the network but we are not yet distributing a route to it or the subnet it will be responsible for (since it is a router after all).

Choose a subnet not already taken and within the `10/8` range and then set this route in your routing table to forward to the local network via one of your interfaces, such as via ethernet on `eth0`:

```
sudo ip route add 10.x.x.x/p proto static dev eth0
```

**TODO:** For the sake of using the router as a host possible set a source hint on the route above

### Setting up CRXN on your laptop

Add a network route for your subnet `10.x.x.x/p` with:

```
sudo ip addr add 10.x.x.x/p dev eth0
```

And then add a route to the rest of CRXN (`10.0.0.0/8`) via your router (where `<ip>` is the IP address of your router chosen earlier):

```
sudo ip route add 10.0.0.0/8 dev eth0 via <ip>
```

### Testing it all

From your router and laptop try ping `10.5.0.1` or `10.0.0.2` for example with:

```
ping 10.5.0.1
ping 10.0.0.2
```

You should see some pongs come back.

To see what route your packets are taking with somewhat accuracy run:

```
traceroute 10.5.0.1
traceroute 10.0.0.2
```

You should see some responses coming back from the intermediary routers.
