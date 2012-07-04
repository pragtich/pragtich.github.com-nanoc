--- 
title: Installing sitecopy on OS X Snow Leopard and using it with Nanoc
kind: article
category: Computer stuff
created_at: November 12, 2011
summary: "I use Sitecopy to upload my Nanoc site to the server. This is how I managed to do it."
---

In order to sync my nanoc site to my provider's server, I have installed sitecopy. Sitecopy requires one of the ports packages. I chose fink, but Darwinports should also work I guess.

First, I downloaded the Xcode and iOS developer software from Apple (registration required as an Apple developer, but free). This installed without issue.

Then, I followed the instructions on the [Fink website](http://www.finkproject.org/download/srcdist.php). The instructions are quite clear I think. I tried to fill in as many local servers as possible while running `./bootstrap`. It would be a shame to transfer everything over the Atlantic cables, right?

What doe surprise me, is that many packages were installed, which I actually already have, many already built into OS X. One that jumped out to me, was python. I can only assume that this is done in order to have all libraries in control of Fink. I just really hope having some programs around twice, does not cause conflicts. fingers crossed...

Now for the real stuff
========

Once sitecopy was running, it actually ran very quickly. I copied an example rakefile [From here](http://www.remerson.plus.com/articles/nanoc-rake) and followed the directory structure suggested by it:

    nanoc/
      site/
        content/
        layouts/
        sitecopy/
          sitecopyrc

So, that is: no dotfiles, all files visible to the filesystem. Of course, this is not the default for sitecopy, so we specify the sitecopy rc file locations in the rakefile.

Then, I created the sitecopyrc as follows:
    
    site my.pretty.name
    server ftp.server.url
    remote /
    local ~/nanoc/pragtich/trunk/output/
    username myFTPusernae
    password thepassword
    protocol ftp

Where the folder after `local` is the nanoc `output` folder.

I then used the initialization from the example rakefile:
    sitecopy -r sitecopy/sitecopyrc -p sitecopy -i my.pretty.name
And crated a 'compile and upload' rake addition to the `Rakefile`:
	
    desc "compile and upload."
	task :co do
	  system 'nanoc co && sitecopy  -r sitecopy/sitecopyrc -p sitecopy -u my.pretty.name'
	end

So now, each time I edit something in my page, I only have to go...

  rake co

...and the entire thing is recompiled and synchronized to the server. 

Mission accomplished!
=======

Update
=====

When I started using `git`, I needed to add a line to the
`sitecopyrc`. I added several of the disturbing dotfiles (which my
server was not allowing me to upload) to the `exclude` list. The
`sitecopy/sitecopyrc` now looks something like:

    site my.pretty.name
    server ftp.server.url
    remote /
    local ~/nanoc/pragtich/output/
    username myFTPusernae
    password thepassword
    protocol ftp
	exclude .DS_Store
	exclude .git
	
This saves a lot of error messages, which eventually led to a failing sitecopy.
    
