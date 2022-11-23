Prefix allocation and registration
==================================

To simply forward IPv6 traffic on CRXN one only needs an IPv6 link-local address which is always guaranteed to be assigned (most of the time), however normally people join CRXN so that they can _also_ host services (and access others) on the inter-network. Therefore, one needs to allocate a prefix and register it to be able to make use of the network in such a manner.

## Generating a prefix (allocation)

On CRXN we use addresses within the `fd00::/8` space otherwise known as the ULA-space. We then require users to generate a random ULA which is a subnet within this space with a prefix size of `/48`.

Here is what a ULA would look like: `fd2d:194b:a02f::/48`

You can generate your ULA you would like to use for CRXN using a tool such as [Unique Local IPv6 Generator](https://www.unique-local-ipv6.com/) or if you are good at basic programming and mathematics you could write a C program to do it.