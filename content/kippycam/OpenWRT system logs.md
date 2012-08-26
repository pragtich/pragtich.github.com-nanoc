--- 
title: System logging with OpenWRT
kind: article
category: Kippycam
created_at: 22 Aug 2012
summary: "Playing around with the syslogd settings in OpenWRT so that debugging is easier"
comment_id: openwrt-syslog
---

I kept running into issues with the Kippycam server router
crashing. Because the default syslog apparently is kept in memory,
these crashes were hard to debug. So I tried to get better (permanent
logging).

Since my router has ample storage space (it's an extroot
with a flash drive), let's start with disk storage:

    > vi /etc/config/system
	
	config system
		option hostname 'Kippycam'
		option zonename 'UTC'
		option timezone 'GMT0'
		option conloglevel '8'
		option cronloglevel '8'
		option log_file '/var/log/messages'
		option log_size '2048'
		option log_type 'file'

	config timeserver 'ntp'
		list server '0.openwrt.pool.ntp.org'
		list server '1.openwrt.pool.ntp.org'
		list server '2.openwrt.pool.ntp.org'
		list server '3.openwrt.pool.ntp.org'
		option enable_server '0'

	config led
		option default '0'

	> /etc/init.d/boot restart
	
	
That's it. A lot larger log file is being kept on the USB stick.

Another idea would be to add a network syslog server. Maybe later.
