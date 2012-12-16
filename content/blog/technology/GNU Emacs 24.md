--- 
title: Switching to GNU Emacs 24 on Mac OS X
kind: article
category: Computer stuff
created_at: 15 Dec 2012
summary: "The new GNU Emacs 24 has native Cocoa support, so I wanted to switch. Not completely trivial, but possible."
comment_id: Emacs24Mac
---
# Introduction

I downloaded the native Cocoa emacs [from here](http://emacsformacosx.com/). Since the new version 24, GNU Emacs is supposed to really work well in OS X. So I am trying what happens if I ditch Aquamacs for GNU Emacs 24. This is how I'm getting on.

# Starting up

Emacs.app does not deliver the standard startup scripts where you
would expect them. And sadly, when you simply `ln -s` the Emacs files
to `/usr/local/bin` or `/usr/bin`, it breaks with a very unfriendly
error message that actually refers to folders that do not exist on
this system, but did on the build system!

	 $ ln -s /Applications/Emacs.app/Contents/MacOS/Emacs emacs
	 $ ./emacs
	 Warning: arch-dependent data dir (/Users/david/src/emacs-dev/ftp-versions/emacs-24.2/nextstep/Emacs.app/Contents/MacOS//libexec/emacs/24.2/x86_64-apple-darwin/) does not exist.
	 Warning: arch-independent data dir (/Users/david/src/emacs-dev/ftp-versions/emacs-24.2/nextstep/Emacs.app/Contents/Resources/share/emacs/24.2/etc/) does not exist.
	 Error: charsets directory not found:
	 /Users/david/src/emacs-dev/ftp-versions/emacs-24.2/nextstep/Emacs.app/Contents/Resources/share/emacs/24.2/etc/charsets
	 Emacs will not function correctly without the character map files.
	 Please check your installation!

This is due to the relocatability of the App, and apparently it does
not handle being launched from the wrong place
properly. [The homebrew people](https://github.com/mxcl/homebrew/issues/6661)
have looked at this and concluded that it is a bug in Emacs. And
[the Macports people have also found it](http://trac.macports.org/ticket/36502). 

I came a long way using the strategies that some of the people on the
web were using, namely with wrapper scripts or functions. Problem is
that these use the OS X builtin `open`, which has several
limitations. For one, it does not allow to load nonexistent files so
you need to make the nonexistent files yourself and delete them
afterwards if not edited. And it breaks the `-nw` option (which you
use to get a text console instead of a graphical frame).

# Solution

## Editing my PATH

In the end, the solution is quite easy. Just gave up and added the
Emacs.app folder to early in my `PATH`. So, added to `~/.bashrc`:

    PATH=/Applications/Emacs.app/Contents/MacOS:$PATH
	export PATH

Strangely, the Emacs.app executable is called `Emacs` instead of the
normal `emacs`. Thankfully, the OS X filesystem is case-insensitive by
default, so it works to type `emacs` anyway.

## Removing the old files and referring to the right emacsclient

The standard emacs that comes with OS X is very old and you really do
not want the confusion between the two versions. So, I did:

    sudo mv /usr/bin/emacs /usr/bin/emacs.orig
	sudo mv /usr/bin/emacsclient /usr/bin/emacsclient.orig
	
And then it is a good idea to put the new `emacsclient` in a standard
location (but not `/usr/bin`, because this is a system place that
could get overwritten whenever Apple wants to):

    ln -s /Applications/Emacs.app/Contents/MacOS/bin/emacsclient /usr/local/bin/emacsclient
	
## Setting up some aliases

In my `~/.bash_profile`, I setup some environment variables to allow
easy access to the editor through the alias `e`. This should
automatically launch emacs when it is not yet running, or connect to
it using `emacsclient` if it is. I had some trouble when `ssh`'ing into the machine, because somehow the correct socket file would not be found. That would give the following error message. It was fixed by adding the `-s` option. This works most of the time, although when autostarting the `Emacs` binary from `emacsclient`, all options are dropped by `emacsclient`, so things like `-nw` will not stick. Maybe I will make a function to copy the arguments and stick them back into Emacs, but this is a marginal case so I will leave it for now. Just need to remember to start Emacs with `-nw` when working in a text only environment.

	emacsclient: can't find socket; have you started the server?
	To start the server in Emacs, type "M-x server-start".
	emacsclient: No socket or alternate editor.  Please use:

		--socket-name
		--server-file      (or environment variable EMACS_SERVER_FILE)
		--alternate-editor (or environment variable ALTERNATE_EDITOR)


I also fill some editor variables that tell other programs that they
should launch emacs when they want to edit a file. This is my
`~/.bash_profile`:

	# Get the aliases and functions
	if [ -f ~/.bashrc ]; then
			. ~/.bashrc
	fi

	# Read autocomplete stuff if present
	if [ -f /sw/etc/bash_completion ]; then
			. /sw/etc/bash_completion
	fi

	test -r /sw/bin/init.sh && . /sw/bin/init.sh

	export EDITOR="emacsclient -s \"/tmp/emacs${UID}/server\" -a Emacs \"\$@\""
	export VISUAL=$EDITOR
	export GIT_EDITOR="$VISUAL +0"

	alias e=$VISUAL


## Setting up server mode
	
To start the emacs server when emacs starts, you need to add the following to `~/.emacs`:

    (server-start)

# Migrating my settings

I am converting from Aquamacs to Emacs 24, so I need to convert my setting file. Aquamacs keeps its settings in the Library: `~/Library/Preferences/Aquamacs Emacs/Preferences.el` and Emacs keeps the settings in the standard location `~/.emacs`. 

I just copied everything in my Preferences.el underneath the skeleton `.emacs` that Emacs 24 had created for me, which contained next to nothing but some default tab settings and some code to enable the `ELPA` package manager.

There are probably some things that I do that are obsolete, but I will sort that out later. For example, Emacs 24 has a built in color theme manager, and I am still referring to an older package. I will try to work with it like this for now, and study the changes as time goes by.

## Some differences

It seems that Aquamacs has some different defaults than GNU Emacs. I changed a few things to become more consistent. First, let's get rid of the startup screen that shows together with your first file (I know how to get help anyway).

    (setq inhibit-startup-echo-area-message t)
	(setq inhibit-startup-message t)
	
	
Then, raising of the windows seems not to be automatic. Whenever I start Emacs from the Terminal, I need to CMD-Tab there. Annoying as hell. [The fix was quite easy, thankfully](http://stackoverflow.com/questions/945709/emacs-23-os-x-multi-tty-and-emacsclient). 

    (select-frame-set-input-focus (nth 0 (frame-list)))

