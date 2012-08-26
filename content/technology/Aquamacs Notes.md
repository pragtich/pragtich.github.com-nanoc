--- 
title: Some notes on using Aquamacs
kind: article
category: Computer stuff
created_at: 13 Jul 2012
summary: "Because I keep forgetting all the little details, I am
writing them down."
comment_id: aquamacs
---
Aquamacs is a great text editor for OS X. It does, however, have its
idiosyncrises. So, here I am keeping notes on what worked for me.

# Documentation

First of all, Google is your friend. But there is also some
[good documentation on the EmacsWiki site][aquamacs-faq].

# Configuration file

The Aquamacs does not use the standard `.emacs` locations. Instead,
the stuff is hidden in the library. For details, check
[the Aquamacs FAQ][aquamacs-faq]. I tend to edit the files in
`~/Library/Preferences/Aquamacs Emacs/` by hand, especially `customizations.el`.

To be honest, this exasperates me so much, that I have learned to use
the 'customization' tool.

[aquamacs-faq]:http://www.emacswiki.org/emacs/AquamacsFAQ

# Emacsclient 

In using Aquamacs, I wanted to start using it as the default
editor. Some research was needed.

## Setup

I edited `.bash_profile` and added the following`;


	# editor setup
	export EDITOR='/Applications/Aquamacs.app/Contents/MacOS/bin/emacsclient'
	export ALTERNATE_EDITOR=vi
	alias e=$EDITOR

Probably I should research how to use ALTERNATE_EDITOR to startup
Aquamacs, but I want to be sure that I am actually on a windowing
station to do that -- too lazy at the moment. Maybe later. As it is
now, Aquamacs will be used when it's running (like when I'm working on
this website), and vi will be used otherwise. 

It also sets up a shorthand editing alias `e` for my convenience.

To get the server to automatically load, I used the customization
interface (Aquamacs -> Preferences, Interfacing to external
utilities, Server) to enable 'Server Mode'. That way, any time
Aquamacs starts up, it will be listening.

## Using

Ending an editing session that was started this way, goes as follows:

    C-x #
	
Many people rebind this key to something like `C-c c` to better match
other applications like GNUS or VCS. Maybe I will too, some day.
