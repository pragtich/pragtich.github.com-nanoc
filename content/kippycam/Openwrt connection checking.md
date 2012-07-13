--- 
title: Keeping Openwrt online using DHCP
kind: article
category: Kippycam
created_at: 13 Jul 2012
summary: When Openwrt loses its connection, it does not very gracefully reconnect when using proto dhcp. This is how I solved this
---
I noticed, when
[installing the WiFi network bridge to the garden shed](network-layout.html),
that the DHCP client does not reconnect when the connection has been
lost. It just sits there (don't know when it would reconnect, maybe
when the lease expires?) unconnected. For my purpose, that's not very
satisfying, as I need the connection to be robust. 

Since I had worked with `monit` before, I figured this would be a
great way to periodically check the state of the connection and
re-enable it when it has dropped out. At a later date, `monit` could
also turn out to be helpful in making sure that all other services on
the router remain healthy. 

# Installing & configuring #

    opkg update
	# I am getting the packages from my local copy of the trunk, just
	to have it all be consistent. That probably is only critical for
	the kernel modules packages, but let's do it for sake of
	simplicity
	
	opkg install monit
	
	vi /etc/monitrc
	
I added some sensible settings from the template that is in
`/etc/monitrc`, mainly to start as a daemon, put the work files in
`/tmp` and set the frequency of the checks. And the check for a
connection:

	check host kiprouter with address 10.0.0.4                                     
        if failed icmp type echo count 3 with timeout 3 seconds then
		exec "/etc/init.d/network restart"

Then to enable and start monit:
	
	/etc/init.d/monit enable
	/etc/init.d/monit start

Testing results later...
