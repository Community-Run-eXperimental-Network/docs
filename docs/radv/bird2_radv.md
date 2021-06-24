Radv
====

This document is for setting up radv on Bird 2.0.

# General syntax

You will want to add one of these to one of your Bird configuration files:

```
protocol radv
{
    # Stuff goes here
}
```

## Advertising your prefix

If you would like to advertise your prefix to hosts on your LAN that have set their address acquisition for IPv6 to _'Automatic'_ such that they will assign themselves an address within that prefix then you will want to add a `prefix` block as so:

```
protocol radv
{
    # Advertise your prefix
    prefix fd40:ec65:5b4c::/64 {
        # TODO: Add anything that needs to be in here
    };

    # Interfaces to run radv on
    interface "eth0";

}
```

In the above example I am advertising a `/64` within my `/48`/ULA (`fd40:ec65:5b4c::/48`), `fd40:ec65:5b4c::/64`, and only on interface `eth0` will radv run.

## Advertising route(s)

You can advertise a default route, to `fd00::/8` or simply all routes in your router's routing table, to your hosts using the following:

### Advertising a single `fd00::/8`

TODO: Add this as I normally don't do this even though one should as it means less memory consumption and advertisement updates

### Advertising all known routes

This will advertise all the routes your Bird router knows (those in the `crxn` table) such that your, laptop for example, will add all of them to its routing table.

```
protocol radv
{
	# Enable propagating of routes exported to us via radv to hosts
	propagate routes yes;

	ipv6 {
		# Export all your routes into the radv advertisement
		export filter crxn6;
		table crxn;
	};

	# Interface to run radv on - only eth0 (change to what you want)
	interface "eth0" {
		# Advertise your prefix
	    prefix fd40:ec65:5b4c::/64 {
	        # Defaults are fine
	    };

		# Prevent advertising of default route
		default lifetime 0;
	};
}
```