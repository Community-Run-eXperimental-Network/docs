IPv6 configuration
==================

Getting IPv6 working on your router is actually easier than IPv4. This is because `babeld` doesn't require you specify an address on the interface which it will use as the next-hop address when redistributing routes from itself to neighbouring routers. Okay, that's a bit of a lie, it **does** require them but when you have IPv6 enabled an interface on Linux it automatically gets an IPv6 link-loal address which will be used as the next-hop address. You still however will want to add an IPv6 address to **any one** of your interfaces though so it can accept packets destined to it, this can be done however on any interface.

## Step 1: Add interface to babel

Enable IPv6 on the interfaces you intend to run `babeld` on. I have no idea how to do this, but by default it is enabled, atleast on Raspbian.

**TODO:** Can someone figure out

## Step 2: Configure babeld

As with the previous tutorial on peering all you need to do is to have an interface line declared in your `/etc/babeld.conf`, nothing really changes just because you are doing IPv6. You will need to make sure you redistribute the following, so add this to your configuration:

```
# Redistribute all CRXN (IPv6 - fd8a:6111:3b1a::/48)
redistribute ip fd8a:6111:3b1a::/48 ge 48
```

## Step 3: Allocate a subnet on Netbox

Now what you need to do is to find a `/56` available in the `fd8a:6111:3b1a::/48` range on Netbox, allocate it, and then a `/64` within said allocated subnet. It is this `/64` that we will be using for configuring your node for IPv6.

You can register a prefix here and find a list of all prefixes [here](https://crxn.chrisnew.de/netbox/ipam/aggregates/8/) and allocate a new one [here](https://crxn.chrisnew.de/netbox/ipam/prefixes/add/).

## Step 4: Add this subnet to your machine

If you recall the `on up` part to your fastd configuration then you can put this code in there if you want. A systemd unit will do as well.

```
ip addr add <subnet>/<prefix> proto static dev <interface>
```

You can make `<interface>` the interface the subnet belongs to, for example, `eth0`, if you intend to have your IPs within your subnet accessed from your router over the LAN it is conneted to on `eth0`.

This above code should add a route for you AND assign the IP to the given interface.
