Entity DB
=========

EntityDB holds all network allocations and associated information. All this must be done on this repository: https://codeberg.org/CRXN/entitydb/

## Format

Firstly create an entry by creating a directory with your unique username, `deavmi/` for example.

### Networks

ALl network declarations are created as seperate files per allocation within `deavmi/networks`. An example would be `deavmi/networks/deavmi.home.network` which must look like this:

```
[deavmi.home.network]
  # Required network information
  Prefix="fdd2:cbf2:61bd::/48"
  PublicKey=""

  # For network connectivity tests
  RouterIP="fdd2:cbf2:61bd::1"
  NonRouterIP="fdd2:cbf2:61bd::2"
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