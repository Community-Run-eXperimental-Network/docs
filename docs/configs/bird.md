Bird configuration
==================

Neil Alexander has provided his Bird config for those who want to run a CRXN router using enterprise software.

```bird
filter crxn4 {
    if source = RTS_STATIC then accept;
    if net ~ [ 10.0.0.0/8+ ] then accept;
    reject;
};

filter crxn6 {
    if source = RTS_STATIC then accept;
    if net ~ [ fd8a:6111:3b1a::/48+ ] then accept;
    reject;
};

protocol static {
    ipv4;
    route 10.4.3.0/24 blackhole;
}

protocol static {
    ipv6;
    route fd8a:6111:3b1a:eeee::/64 blackhole;
}

protocol babel {
    randomize router id yes;
    ipv4 {
        import filter crxn4;
        export filter crxn4;
    };
    ipv6 {
        import filter crxn6;
        export filter crxn6;
    };
    interface "crxn*" {
        type wired;
    };
}

protocol device {
    scan time 60;
}

protocol direct {
    ipv4;
    ipv6;
}

protocol kernel {
    ipv4 {
        export all;
        import none;
    };
}
```
