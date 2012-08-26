--- 
title: Using Nanoc to fill Github Pages
kind: article
category: Computer stuff
created_at: 04 Jul 2012
summary: "Learning to use git to update GitHub Pages -- a free web
server."
comment_id: nanoc-github
---
Started out with an already-existing nanoc folder.

I Installed git for mac using the standard installer supplied on
git-scm.com (version 1.7.11.1) and created an account on github.

Created a repository called <username>.github.com

[Followed (approximately) this link](http://schmurfy.github.com/2011/05/06/create_your_github_user_page_with_nanoc.html)
although I made a few changes.

First of all, I already had a checkin, so could skip the first code
box. I did rename the `master` branch to `source` and add a second remote:

	git branch -m master source
	git remote add pages https://github.com/<user>/<user>.github.com.git
	git push -u pages source
   
The output sounds promising:

	Counting objects: 102, done.
	Delta compression using up to 2 threads.
	Compressing objects: 100% (95/95), done.
	Writing objects: 100% (102/102), 237.00 KiB, done.
	Total 102 (delta 19), reused 0 (delta 0)
	To https://github.com/pragtich/pragtich.github.com.git
	 * [new branch]      source -> source
	Branch source set up to track remote branch source from pages.

The `source` branch now holds the entire page source (including
any output).

Now I followed the cloning instructions quite rigidly (because I do
not really understand them yet).

	# fetch a working copy of your repository
	  $ git clone https://github.com/<user>/<user>.github.com.git output
	  $ cd output
	# create the isolated branch
	  $ git symbolic-ref HEAD refs/heads/master
	  $ rm .git/index
	  $ git clean -fdx

Then recreate the output files:

    cd ..
	nanoc compile
	git commit -a
	git push pages
	cd output/
	git add *
	git commit
	git push origin master
	
The `git push origin master` part was tricky to figure out to me. It
pushes the output folder's content to it's set remote origin (which
came from the `clone`, I assume. Adding the `master` determines that
the files are going into the `master` branch (which is the leading
branch for the GitHub Pages).

Finally, I did:

     touch .nojekyll
	 git add .nojekyll
	 git commit
	 
	 vi .gitignore       #add .nojekyll to this file

This should put a .nojekyll file into the repository, that will not
get clobbered when I nuke the output/ folder (I hope).

So now, the workflow is:

1. Update files in the `content/` folder
2. Compile and upload to test server (I use a rake file)
3. Verify results
4. In the source folder: `git commit -a; git push pages`
5. In the output folder: `git commit -a; git push origin master`

**TODO**: Add a rakefile to auto-push both the source and the output once
I have a satisfactory build.


Pushing using nanoc-git
===================

I am playing with nanoc-git. I found it through a Google search. It's
maker claims it to be alpha-level software. Let's see. It lives
[here](https://github.com/cspicker/nanoc-git).

The script does rebuild the output folder implicitly. So it breaks the
prototyping build thing that I have described above. Maybe I'll try to
rewrite it to allow some kind of prototyping, or maybe I will stick
with the plan before. I will see. Good thing I'm keeping this blog,
because I tend to forget each syntax before I get to use it again.

For sake of documentation, I did the following:

* Updated `config.yaml`:

		# Additions for nanoc-git: http://graysky.org/2008/12/git-branch-auto-tracking/
		deploy:
		  default:
			dst_remote: pages
			dst_branch: master
			src_branch: source

* Installed nanoc-git:

         gem install nanoc-git
	
* Edited `Rakefile`

        require 'nanoc-git/tasks'
	
Then, to execute: `rake deploy:git' should 

1. Clean the nanoc site
2. Check out the source (`source`) from `git`
3. Compile the site using `nanoc`
4. Check out the destination (`master`) from `git`
5. Copy all the files from the `output/` folder to the root of
`master`
6. Commit in `git`
7. Push to the remote `master`
8. Check the source back out

A possible workflow could be:

    # Edit the file 
	git add <file>
	git commit 
	rake co  #this is my prototyping (sitecopy) rake
	
	# Check: ok?
	
	rake deploy:git

or another option:

    # Edit the file 
	rake co  #this is my prototyping (sitecopy) rake
	
	# Check: ok?

	git add <file>
	git commit 
	
	rake deploy:git



	
# Getting a domain name #

I registered `pragti.ch` at [nic.ch](http://nic.ch) and organized a
free DNS service to do the DNS hosting. Then, tried to set up the
CNAME following
[the documentation at Github](https://help.github.com/articles/setting-up-a-custom-domain-with-pages).

    git checkout master
	vi CNAME
	# just one line: 
	# pragti.ch
	
	git add CNAME
	git commit
	git push pages
	git checkout source
	
Did not work immediately, but many times DNS can take some time to
update. Let's wait and see.
