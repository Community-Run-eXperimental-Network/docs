Configuring Bird
================

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

