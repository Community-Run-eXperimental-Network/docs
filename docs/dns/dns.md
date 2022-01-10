CRXN DNS
========

**CRXN DNS** offers users the ability to map their CRXN IP address to human-readable names to make life easier. The way DNS is managed on CRXN is via the [RecordDB](http://codeberg.org/CRXN/zones/src/branch/master/all) whereby you make a pull request to add your entries and it gets approved by one of the network administrators. The time for the new records to reflect is dependent on which root nameserver your choose to use.

## Root nameservers

1. **Deavmi's root nameserver**:`fd08:8441:e254::4` (`dns1.crxn`)
	1. This server updates records every 10 minutes
	2. Provides clearnet name resolution as well