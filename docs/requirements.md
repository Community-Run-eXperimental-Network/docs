Requirements
============

This document aims to provide a rough ideas of the requirements for joining CRXN.

## Hardware

In terms of hardware there is not really any constraint - you can run a node on whatever hardware you like. If anything, we advocate for a diversity of hardware use as it allows the software used such as `bird`, `fastd` etc. to be tested in a multitude of different ways within the domain of networking.

**However**, please do not use hardware that is extremely slow in terms of CPU performance. Routing still takes some CPU time and it needs to be relatively fast. Most hardware won't be as slow as what we are describing here but some can be.

### Bandwidth

Your network should be able to handle relatively high throughput. We recommend 50mbit up/down as a bare minimum, currently we don't push high throughput data through our networks but the room for growth is better to have than not.