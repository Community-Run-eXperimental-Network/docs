SLAAC
=====

Configuring your hosts for automatic IP network and address assignment, DNS and routing is very easy.

## NetworkManager-based systems

For NetworkManager-based systems do the following. Open up `nm-connection-editor` and you should have a screen appear like this:

![](slaac/nm-connection-editor.png)

Then double click on the wifi or ethernet connection you have active of which connects you to the same LAN as your router and you should see a window like this popup:

![](slaac/nm-connection.png)

Then go to the `IPv6` tab and you should see this:

![](slaac/ipv6-nm-connection.png)

Now make sure that this part is set to `Automatic`:

![](slaac/address_acquisition_automatic.png)

And then for the bottom two parts you can choose whatever option you want in these dropdowns:

![](slaac/whatever_you_want.png)

Once you have configured that, then hit save and close all those windows:

![](slaac/save_connection.png)

What you want to do now is to open `nmtui` (in your terminal) and reactivate that connection, first go to _Activate a connection_:

![]()

Now reactivate the connection. You can do this by deactivating it and activating it again (unplugging and replugging won't reactivate it - it doesn't reload the profile).

![]()