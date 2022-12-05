IPv6 forwarding
===============

TODO: Move this to another page

## Enabling forwarding

We will be setting up the machine that runs bird as a router so therefore
we need to make your Linux kernel's network stack not drop IPv6 packets
that it receives (addressed to it via Ethernet) but are not addressed to
it via IPv6 address - in other words it must try do something with these packets,
namely attempt to forward them one hop closer to their initial destination.

Enabling forwarding on all interfaces can be achieved as follows (you will need
to be root):

```bash
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
```

However, after reboot it won't be saved and will go back to its defaults. Therefore
what you need to do is to enable forwarding on boot-up, this can be done by
adding an additional line to your `/etc/sysctl.conf` (which holds a bunch of
these statements), it should look like this:

```bash
net.ipv6.conf.all.forwarding=1
```

TODO: Weird experience with me, only doing `all` made it work

## Assigning the /64

TODO: Do something with this later

Normally people will assign a `/64` out of their `/48`. Assign this to the interface of the LAN you want your router on.

A good IP choice for the router would be either `xxxx::1` or `xxxx::` so people can easily guess what to ping to test reachability to your network.
