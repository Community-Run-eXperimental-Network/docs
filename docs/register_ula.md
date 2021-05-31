Registering a subnet
====================

Before we get started with configuring any sort of routing you first need to get yourself a network allocated to yourself.

## Generating a /48 ULA

We highly recommend you register a new `/48` ULA on the [Ungleich ULA registry](https://ula.ungleich.ch/) - this way we can ensure that the ULA is stored in a global database to prevent clashes (even though the probability is low).

Firstly register a new account with them and you should see the homepage as follows then:

![](/img/prefix_registration/homepage_ungleich.png)

Then go to the "Register random prefix" section:

![](/img/prefix_registration/register_ungleich.png)

On this page fill in the fields, for the `URL` field put `http://deavmi.assigned.network/projects/crxn`. As for the `Organization` set that to `CRXN` and then for the `Network` section set that to be whatever you want to name your network (remember this as we will need it later).

![](/img/prefix_registration/prefix_page_ungleich.png)

After filling this in then hit submit and you should see a blue pop up with your allocation, save this, this is **very important**.

![](/img/prefix_registration/generated_prefix.png)

Now you have successfully allocated yourself a /48 ULA on Ungliech, `fd40:ec65:5b4c::/48`, next we will register it on the CRXN registry.

## Registering your prefix on CRXN registry

Now you will need to register your prefix, i.e. `fd40:ec65:5b4c::/48`, on our [Netbox instance](http://crxn.chrisnew.de/netbox) but you will need to get an account there. What I can recommend is you drop an email to `deavmi@redxen.eu` with your prefix and I can register it for you **or** create an account for you (this way you can register more without having to wait on me and also sub-allocations within your prefix).

Once this is done then we will be ready to start setting up routing!