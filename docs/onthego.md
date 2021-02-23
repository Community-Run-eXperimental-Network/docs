CRXN On-the-go
==============

If you don't want to have to setup your **own router** or if you are away from a router itself and don't want to run one directly on your laptop and peer with someone then you can make use of someone else's router. A user, _caskd_, has made this possible. He provides IPv6-only and clearnet VPN tunneling over Wireguard - giving you access to all of IPv6 CRXN easily on Android, iOS or Linux, Mac OSX or Windows (any platform that Wireguard supports).

The configuration template is as follows:

```
[Interface]
PrivateKey=<private key>
Address=<ipv4 address>/32, <ipv6 address>/128
DNS=172.22.12.1

[Peer]
PublicKey=GJ8korU5yeAXpixMiaOohdRS4TSJ+Ag/5cLN1j6NMGA=
AllowedIPs=0.0.0.0/0, ::/0
Endpoint=168.119.99.213:51820
```

You just need to fill in your `<private key>`, `<ipv4 address>` and `<ipv6 address>`.

Contact [caskd@redxen.eu](mailto:caskd@redxen.eu) to request a connection.
