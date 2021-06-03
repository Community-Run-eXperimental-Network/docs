Entity DB
=========

EntityDB holds all network allocations and associated information. All this must be done on this repository: https://codeberg.org/CRXN/entitydb/ or you can send an email to (TODO: add rany's email).

## Format

Firstly create an entry by creating a directory with your unique username, `deavmi/` for example.

### Networks

All network declarations are created as entries in the file `deavmi/network` as so:

```
[deavmi.home.network]
  # Required network information
  Prefix="fdd2:cbf2:61bd::/48"
  PublicKey=""

  # For network connectivity tests
  RouterIP="fdd2:cbf2:61bd::1"
  NonRouterIP="fdd2:cbf2:61bd::2"

[deavmi.community.network1]
  # Required network information
  Prefix="fd08:8441:e254::/48"
  PublicKey=""

  # For network connectivity tests
  RouterIP="fd08:8441:e254::1"
  NonRouterIP="fd08:8441:e254::2"
```

### Services

All network services are declared within `deavmi/services` (file) like so:

```
[Web server]
  address="fdd2:cbf2:61bd::2"
  port=80
[Babel web]
  address="fdd2:cbf2:61bd::2"
  port=4444
```