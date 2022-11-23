<center>
	<img src="logo.png" width="300">
</center>

<br>

<center>
	<h1>CRXN</h1>
</center>

## What is it?

<img src="map.png" width=30% height=30% style="float:right;gap;margin-left:20px">

CRXN stands for **C**ommunity **R**un e**X**pansive **N**etwork. It's a computer network _run by the community for the community_.
We provide an IPv6 (that's the freshest Internet Protocol out there to date) and on CRXN anything that can speak IPv6
will be able to function correctly - a network without borders! We are focused with having a network that really focuses
on the "end-to-end" principal of IP - that is to say that if you want to run something and make it available to other then
you won't have to worry about NAT-traversal, port forwarding, lack of raw IP support and all the other non-sense that IPv4
created (due to lack of addresses).

Compared to the clearnet (normal Internet) there isn't much fuss involved around getting
a network ID assigned to you and so forth, we truly are for the community and all our members take some of their own time
to work on their network and the greater CRXN inter-network as a whole.

It's a great place to test out new protocols, networking projects, play games, exchange ideas and learn about networking,
routing and network sub-systems themselves. You also get to learn how CRXN is put together which is a great way to learn
networking with those that run networks already themselves.

## Our goals

The network has a few goals that we always want to maintain as to not lose our allure:

1. Be a network for learning
	* We don't want to shun people away from using some new
	routing protocol as it might be cool and interesting to
	learn
2. Be reliable
	* Of course when learning people should also make sure
	their routers don't just accept any route without making
	sure its valid - hence network operators should make sure
	their networks operate even when some are causing mayhem
	(malicious or learning by trial and error)
	* Also shouldn't be painfully slow
3. Diverse routing
	* We want to try out protocols like **ospf**, **babel**, **bgp**
	and so on and so forth
	* We want to build a network out of a mix and match of these all
	working in harmony together
	* Monocultures suck!
4. Usable
	* We have DNS, we have voice chat servers and we have IRC (we
	even have gaming!) but we can always do with much **much more**!
	* We want the users, _you_, to make the network usable for your
	needs - who knows it might provide a service that helps out
	someone else
5. Peering
	* We want people to setup redundant links using whatever protocols
	they want, be it **wireguard**, **GRE**, **fastd** etc.
	* We want there to be interesting links and diversity
6. _Chaos and Order_
	* The network should never stop experimenting
	* But it should have 99% uptime and safety fallbacks
	* If you want to experiment - then go ahead and try cause
	as little disruption as possible
	* If you run a node - make it secure - sign routes etc.
	to prevent others from experimenting from messing your
	network up

We aim to create a more open Internet available to everyone and a place to learn about IP routing and networking in general.

We don't use any particular tooling, the only thing that is standard is the IPv4 and IPv6 part. What tunnelling software, physical
mediums or routing daemon you choose to use is up to you - this falls in line with our _open_ ethos.

## About the network

A few details about the network.

### Protocol support

We only use IPv6 on CRXN because it has many features, such as link-local addresses, that make
setting up dynamic routing protocols near-zero-config.

It's also the modern way of the Internet and means you will get a large space of addresses
assigned to you.

### The range

The IPv6 range we use is the private range of `fd00::/8`.

### Assignments

Users get allocated a `/48` (like `fdd2:cbf2:61bd::/48`) IPv6 ULA within the `fd00::/8` range (by definition).

We keep track of allocations on a Git-based repository called [_EntityDB_](https://codeberg.org/CRXN/entitydb).

## Getting started

### Joining the network

Does it sound interesting enough for you already? Want to get connected? Then head on over
to our [Getting started] section where you can find all the guides you need in order to get connected,
follow the rules and have fun!

---

## Important links

Some important links to remember.

* The CRXN homepage is: [http://deavmi.assigned.network/projects/crxn](http://deavmi.assigned.network/projects/crxn)
* The **EntityDB** repository is: [https://codeberg.org/CRXN/entitydb](https://codeberg.org/CRXN/entitydb)
* This documentation is at: [https://github.com/Community-Run-eXperimental-Network/docs](https://github.com/Community-Run-eXperimental-Network/docs)