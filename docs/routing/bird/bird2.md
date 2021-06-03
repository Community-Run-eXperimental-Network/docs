Configuring Bird 2
==================

This document aims to provide the configuration file template required
for CRXN and along with a description of what parameters need to be set
for your node specifically.

## Configuration

The configuration template is constructed out of the following files:

1. `filters.conf`
	* Filter functions and the filter itself
2. `networks.conf`
	* Advertisement of ULA
3. `tables.conf`
	* The table definitions
4. `router.conf`
	* This contains the needed protocol definition for discovering
	your interface's prefixes and generating routes form them
	* It also contains the needed protocol definitions to sync bird
	routes into the Linux kernel's routing table (so you cna forward
	packets based on the routes from Bird)
5. `protocols.conf`
	* Depending on what protocol you want to use this will contains
	configurations for each

All of these will be included in a file saved at `/etc/crxn/bird.conf` like so:

```
router id <ipv4>;

include "/etc/crxn/filters.conf";
include "/etc/crxn/networks.conf";
include "/etc/crxn/tables.conf";
include "/etc/crxn/router.conf";
include "/etc/crxn/protocols.conf";
```

Remember to set a unique router ID in `<ipv4>`, make it anything - it doesn't have to even be an address you own.

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

# CRXN Route filter based
filter crxn6
{
	# CRXN v6 range
        if (rangeCheck(net, fd00::/8) = true)
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
ipv6 table crxn;
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
        ipv6
        {
                # Import from direct -> bird into bird's `crxn` table
                import filter crxn6;
                table crxn;
        };
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
        ipv6 {
        	# Export from bird -> kernel from bird's `crxn` table
                export filter crxn6;
                table crxn;
        };
}
```

#### `networks.conf`

This is just something we normally add. Usually you would assign a `/64` within your ULA `/48` but you also want to claim the whole `/48` by advertising a blackhole for it. Here our `/48`/ULA is `fd40:ec65:5b4c::/48`.

```
protocol static crxnStatic
{
        # Advertise your /48 with a blackhole
        route fd40:ec65:5b4c::/48 blackhole;

        ipv6 {
                import filter crxn6;
                table crxn;
        }
}
```

#### `protocols.conf`

This file should look like this (as an example of running one `babel`
instance and one `ospf` instance):

```
# Import protocol instances
import "babel.conf";
import "ospf.conf";
```
