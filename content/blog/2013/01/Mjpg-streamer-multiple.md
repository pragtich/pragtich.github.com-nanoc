--- 
title: Using multiple webcams in mjpg-streamer on OpenWRT
kind: article
category: Computer stuff
created_at: 02 Jan 2013
summary: "OpenWRT actually contains everything needed to run two or even more webcams with mjpg-streamer. But there is a bug in the init script that prevents it from working properly. This is an easy fix."
comment_id: mjpg-streamer-init-fix-mult
---

# The init file problem

For my Kippycam project, I am trying to run the mjpg-streamer with various instances, so that I can stream from multiple cameras from my TL-WR3020 or TL-WR703N routers. There is a nice init and config system that comes with the mjpg-streamer package in OpenWRT, that does most of the work. It puts configuration for the server in the UCI file `/etc/config/mjpg-streamer`, and the `/etc/init.d/mjpg-streamer` script actually loops over any possible configurations already. So, to instantiate multiple servers, I only need to add a second server definition in the config file. 

BUT, then I get the following error in the logfile, and the second server does not start:

	Jan  2 09:41:32 OpenWrt user.info MJPG-streamer [1580]: Using V4L2 device.: /dev/video0
	Jan  2 09:41:32 OpenWrt user.info MJPG-streamer [1580]: Desired Resolution: 640 x 481
	Jan  2 09:41:32 OpenWrt user.info MJPG-streamer [1580]: Frames Per Second.: 2
	Jan  2 09:41:32 OpenWrt user.info MJPG-streamer [1580]: Format............: MJPEG
	Jan  2 09:41:32 OpenWrt user.info MJPG-streamer [1580]: init_VideoIn failed

The key is they incorrectly detected device name `/dev/video0` for the second camera. This is simply the default hardcoded into mjpg-streamer. It is not properly picking up the device name. Then, trying to open `/dev/video0` a second time, will of course fail.

# The solution

I do not understand the root cause fully, but it is clear that the `/etc/init.d/mjpg-streamer` script contains some layout so that it is more legible. This layout does, however, introduce some whitespace into the command line that is causing our trouble. I will leave analysis of the true root cause to the experts, but describe the quick and dirty solution.

This is a part of the original file, below. The problem is with the line continuation with slashes.


	start_instance() {
		local s="$1"

		section_enabled "$s" || return 1

		config_get device "$s" 'device'
		config_get resolution "$s" 'resolution'
		config_get fps "$s" 'fps'
		config_get www "$s" 'www'
		config_get port "$s" 'port'

		[ -c "$device" ] || {
			error "device '$device' does not exist"
			return 1
		}

		service_start /usr/bin/mjpg_streamer --input "input_uvc.so \   # <=== Problem is here
			--device $device --fps $fps --resolution $resolution" \
			--output "output_http.so --www $www --port $port"
	}


I simply removed the backslashed line continuations and put everything in one line, and that solves the issue for me:

		service_start /usr/bin/mjpg_streamer --input "input_uvc.so --device $device --fps $fps --resolution $resolution"  --output "output_http.so --www $www --port $port"


# Correcting PIDfile issue

There is a second issue, because the default `service_start` behaviour is to prevent starting of multiple instances of the same daemon. So, we need to explicitly make sure that it does make multiple instances for us (because we are asking nicely). There are several ways to this, but I chose to explicitly help by supplying a pid file name for each camera. By using the unique configuration name from the config file, these will be unique. It is an easy edit in two places of `/etc/init.d/mjpg-streamer`. First, the function `start_instance` again:

	start_instance() {
		local s="$1"

		section_enabled "$s" || return 1

		SERVICE_PID_FILE=${PIDLOC}-${s}.pid

		config_get device "$s" 'device'
		config_get resolution "$s" 'resolution'
		config_get fps "$s" 'fps'
		config_get www "$s" 'www'
		config_get port "$s" 'port'

		[ -c "$device" ] || {
			error "device '$device' does not exist"
			return 1
		}

		service_start /usr/bin/mjpg_streamer --input "input_uvc.so --device $device --fps $fps --resolution $resolution"  --output "output_http.so --www $www --port $port"

	}

So in short, I generate a `$SERVICE_PID_FILE` that uniquely identifies the service. Of course, for killing the service we need to go back to the same pidfile:

	stop_instance() {
		local s="$1"

		section_enabled "$s" || return 1


		SERVICE_PID_FILE=/var/run/mjpg-streamer-${s}.pid

		service_stop /usr/bin/mjpg_streamer
	}

# Configuration

Now, it is really easy to edit `/etc/config/mjpg-streamer` for multiple devices. Do be careful not to exceed the memory of your device, and also the USB and memory bandwidths, or you may make the device very unstable. Adding a name for each `config` heading is not strictly necessary, but very helpful as it gives some identification. I am assuming that each device has a fixed `/dev/video` devicename, which is the case on my device as long as I do not replug any camera.

This is my config file:

	config mjpg-streamer c920
		option device		"/dev/video0"
		option enabled		"1"
		option resolution	"960x720"	
		option fps		"3"
		option www		"/www/webcam"
		option port		"8080"

	config mjpg-streamer logi
		option enabled		"1"
		option device		"/dev/video1"
		option resolution	"640x480"
		option fps		"2"
		option www		"/www/webcam"
		option port		"8081"

# Version update

The packages version of the mjpg-streamer was old. I actually compiled my own version of mjpg-streamer by updating the packages `Makefile` in the OpenWRT buildroot. A nice description of the process of building with buildroot is what I roughly followed [from this post in the forums](https://forum.openwrt.org/viewtopic.php?id=34676), which links to [this wiki page after installing the prerequesites](http://wiki.openwrt.org/doc/howto/build). After `./scripts/feeds install -a`, I found the Makefile for mjpg-streamer (somewhere in `tmp`, if I remember correctly) and updated it to the latest SVN revision number. This did solve some instability issues I was facing with random reboots, so I highly recommemd going this way. 

Again, maybe I should learn how to submit patches for OpenWRT to help improve it...
