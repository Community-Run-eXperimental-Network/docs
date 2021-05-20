Configuring Bird
================

This document aims to provide the configuration file template required
for CRXN and along with a description of what parameters need to be set
for your node specifically.

## Bird 1.6 and 2.0 differences

Bird 1.6's bird6 (which is what we will use) doesn't prefix anything
with `ipv6` as they are assumed to all be IPv6. However, in bird 2.0,
it is dual-stack and hence one must provide either an `ipv6` prefix or
`ipv4` (we will of course be using the former).

### Changes

#### Table definitions

So for example in 1.6 bird6 a table definition is as follows:

```bird
table crxn;
```

However in bird 2.0 it is as follows:

```bird
ipv6 table crxn;
```

#### Channels

So for example in 1.6 bird6 a channel definition is as follows:

```bird
import all;
export all;
```

However in bird 2.0 it is as follows:

```bird
ipv6 {
	export all;
	import all;	
};
```

---

## Configuration

The configuration template is constructed out of the following files:

1. `filters.conf`
	* Filter functions and the filter itself
2. `networks.conf` (TODO: Add at a later stage)
3. `tables.conf`
	* The table definitions
4. `router.conf`
	* This contains the needed protocol definition for discovering
	your interface's prefixes and generating routes form them
	* It also contains the needed protocol definitions to sync bird
	routes into the Linux kernel's routing table (so you cna forward
	packets based on the routes from Bird)

#### `filters.conf`

This file holds all the required functions for subnet matching and also
filters that match to the specific prefix aggregates (regional subnets)
that CRXN uses.

```
# Given prefix `in` and `check` see whether or not
# the `in` is withint `check`
function rangeCheck (prefix inPrefix; prefix rangePrefix)
int ourNetworkLen;
ip ourNetworkID;
ip inPrefixMasked;
{
        # Get the length of our range
        ourNetworkLen=rangePrefix.len;

        # Get out network ID
        ourNetworkID=rangePrefix.ip;

        # Mask the inPrefix to that length
        inPrefixMasked=inPrefix.ip.mask(ourNetworkLen);

        # Check if the masks match
        if(inPrefixMasked = ourNetworkID)
        then
                return true;
        else
                return false;
}

# CRXN Route filter based on regions
filter crxn6
{
        # Allowed ranges (CRXN ranges)
        # European CRXN: fd8a:6111:3b1a::/48
        # Souther African CRXN: fded:4178:23fe::/48
        # Indian: fdfa:1685:3d1::/48
        # Russian: fda1:8885:300d::/48
        # American: fd68:b488:442c::/48
        # Freeloader's IPv6: 2a04:5b81:2050::/44
        if (rangeCheck(net, fd8a:6111:3b1a::/48) = true)
        then
                accept;

        if (rangeCheck(net, fded:4178:23fe::/48) = true)
        then
                accept;

        if (rangeCheck(net, fdfa:1685:3d1::/48) = true)
        then
                accept;

        if (rangeCheck(net, fda1:8885:300d::/48) = true)
        then
                accept;

        if (rangeCheck(net, fd68:b488:442c::/48) = true)
        then
                accept;

        if (rangeCheck(net, 2a04:5b81:2050::/44) = true)
        then
                accept;



        # No matches, reject
        reject;
}
```

#### `tables.conf`

This file holds all table definitions. There are only two actually.
The table `crxn` is the one we actually use, `master` is optional
and is only present because if one uses `bird-lg-go` (the looking glass
we use) then it, by default, only shows routes in the `master` table.
It is meant to have the same routes as the `crxn` table.

```
# CRXN table
table crxn;

# master table

# This is the default table, I only use this as the looking glass defaults to looking at it

table master;
```

#### `router.conf`

This contains an instance of the `direct` protocol which reads the address
and prefix assigned to your AF_INET6 interfaces and generates routes from
those that represent routes to directly atrtached networks those interfaces
are on. The reason for this is that the `kernel` protocol never learns routes
in the Linux kernel's routing table that have the `kernel` protocol which
is what you get when you assign interfaces addresses and prefixes. This
doesn't even need those, it gets them from the interface.

```
# The kernel protocol doesn't grab kernel routes that are added by you when you assign an
# address and prefix. So instead of reading this from all routes with `proto kernel` this just
# yeets the routes off of the interface structure itself (even if you didn't have a route for your
# directly attached networks - i.e. nexthop = 0.0.0.0)
protocol direct crxnDirect {

        import filter crxn6;
        table crxn;

        import filter crxn6;
        table master; #Only doing this so it shows by default in looking glass
}
```

The second part is for syncing routes from Bird to the Linux kernels' routing
table such that you can forward traffic then absed on the routes learnt from
Bird.

TODO: Check, defualt `learn` should larn non `kernel` and non-`bird` routes

```
# CRXN Kernel protocol
# We import any routes from the kernel table other than `proto bird` and `proto kernel`,
# could be `proto static` for example. By default it will learn these.
# Of course we also then export all routes from our Bird tables into the kernel so you can actually forward packets
protocol kernel crxnKernel {
                import filter crxn6;
                export filter crxn6;

                table crxn;
                table master; #Only doing this so it shows by default in looking glass
}
```