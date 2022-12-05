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

All of these will be included in a file saved at `/etc/bird/bird.conf` like so:

```
router id <ipv4>;

include "/etc/bird/crxn/tables.conf";
include "/etc/bird/crxn/filters.conf";
include "/etc/bird/crxn/router.conf";
include "/etc/bird/crxn/networks.conf";
```

Additionally, add the files for the route distribution protocol which we configure in the next steps.
```
include "/etc/bird/crxn/babel.conf"; # For babel routing
include "/etc/bird/crxn/ospfv3.conf"; # For OSPFv3 routing
```

Remember to set a unique router ID in `<ipv4>`, make it anything - it doesn't have to even be an address you own.

#### `filters.conf`

This file holds all the required functions for subnet matching and also
filters that match to the specific prefix aggregates (regional subnets)
that CRXN uses.

```
filter crxnFilter
{
    if (net ~ fd00::/8) then accept;
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
protocol direct crxnDirect
{
    ipv6
    {
        table crxn;
        import filter crxnFilter;
    };
    # Interfaces to find neighbours on
    interface "eth*";
}

protocol device {
}
```

The second part is for syncing routes from Bird to the Linux kernel's routing
table such that you can forward traffic based on the routes in Bird.

TODO: Check, defualt `learn` should learn non `kernel` and non-`bird` routes

```
# CRXN Kernel protocol
# We import any routes from the kernel table other than `proto bird` and `proto kernel`,
# could be `proto static` for example. By default it will learn these.
# Of course we also then export all routes from our Bird tables into the kernel so you can actually forward packets
protocol kernel crxnKernel
{
    ipv6 {
        # bird's crxn table -> kernel
        table crxn;
        export filter crxnFilter;
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
