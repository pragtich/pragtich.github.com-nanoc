--- 
title: Compiling a modified GStreamer for the C920 webcam
kind: article
category: Computer stuff
created_at: 19 Jul 2012
summary: The Logitech C920 offers H264 encoding onboard. But not many programs can make use of it. I am trying to compile a patched GStreamer module that allows streaming of H264 directly from the C920 camera.
---
# Satisfying build requirements #
## Packages

Basically, a matter of `make prereq` and `sudo fink install xxx` until
all dependencies were met.

## Filesystem ##

The OpenWRT buildroot needs a case-sensitive filesystem and tells you
that:

    Build dependency: OpenWrt can only be built on a case-sensitive
    filesystem
	
The default OS X system is not case sensitive. There is a simple
solution: create a separate disk image. As I found
[here](https://forum.openwrt.org/viewtopic.php?id=20914):

    hdiutil create -size 2048m -fs HFSX -volname openwrt openwrt
	Doubleclick the dmg
	cd /Volumes/openwrt/
	tar cf - ~/openwrt | tar xfp -

Also, I found the following tips that may be necessary (?) in the same
forum topic:

    A couple notes on using MacOS X as a build environment that I've found so far:

	Package names for "port" that you may need:
	* gmake
	* gawk
	* gtar
	* coreutils
	* findutils
	* getopt
	* wget

	(There may be others, I can't easily do a "clean install" on Mac)

	$ export PATH="/opt/local/bin:$PATH"   # so that the GNU versions get picked up



	You may need to

	$ chmod +x scripts/md5sum    # appears to be "fixed" in current trunk


	As suggested by marca, update XTools and re-symlink (gcov not required, AFAIK, but consistency is good)

	/usr/bin/g++ -> g++-4.2
	/usr/bin/gcc -> gcc-4.2
	/usr/bin/gcov -> gcov-4.2


	If you want to build the documentation, MacTeX will do it -- http://www.tug.org/mactex/
	(though there is no BSD-make wrapper in that directory, so gmake in the docs directory)

# Compiling

    make menuconfig
	
	# selected ar7xx, minimal profile, toolchain and sdk
	
	make tools/install
	make toolchain/install
