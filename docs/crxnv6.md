IPv6 configuration
==================

Getting IPv6 working on your router is actually easier than IPv4. This is because `babeld` doesn't require you specify an address on the interface which it will use as the next-hop address when redistributing routes from itself to neighbouring routers. Okay, that's a bit of a lie, it **does** require them but when you have IPv6 enabled an interface on Linux it automatically gets an IPv6 link-loal address which will be used as the next-hop address. You still however will want to add an IPv6 address to **any one** of your interfaces though so it can accept packets destined to it, this can be done however on any interface.

