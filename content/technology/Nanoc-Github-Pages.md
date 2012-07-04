--- 
title: Using Nanoc to fill Github Pages
kind: article
category: Computer stuff
created_at: 04 Jul 2012
summary: "Learning to use git to update GitHub Pages -- a free web server."
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

