Configuring Bird2
=================

We now need to configure the routing daemon for your router which will allow you to
exchange routes with other routers over the tunnels you will setup later. This is at
the core of what makes CRXN an inter-network. 

The software we use for this procedure is known as BIRD or _BIRD Internet Routing Daemon_,
of which there are two versions:

1. Bird 1.6
2. Bird 2

You can use Bird 1.6 but you are on your own then in terms of configuration, the syntax
differs slightly but we recommend (and for the rest of this document we will be) using
Bird 2 as it comes with many bug fixes and improvements and most distributions (including Debian)
now have support for it.