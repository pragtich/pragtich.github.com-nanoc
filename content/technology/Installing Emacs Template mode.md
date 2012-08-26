--- 
title: "Easy new page creating using Emacs and Template.el"
kind: article
category: Computer stuff
created_at: 14 Nov 2011
index_image: Nanoc_index.jpg
summary: "How I installed Template.el to help make blogging quick in
Emacs"
comment_id: template-mode
---



installing Emacs Template mode in Aquamacs. Based on [This web site](http://emacs-template.sourceforge.net/details.html).

Downloaded and put the template.el file into `~/.xemacs/lisp`. 
Visit the file and `  M-x byte-compile-file RET template.el RET`. Loads of errors.

Put into Emacs settings (Library in Aquamacs):
    (require 'template)
    (template-initialize)
    M-C-x

Copied example templates to ~/.templates.

Restarted Emacs

Read the [manual](http://emacs-template.sourceforge.net/details.html).
* `C-x t` Creates a file with template
* `template-new-file` Should do the same
* I want to try and disable it from `C-x C-f` -- that would only be confusing

Created the following empty markdown article with Nanoc header in `~/.templates`:

	--- 
	title: (>>>TITLE<<<)
	kind: article
	category: Computer stuff
	created_at: (>>>DATE<<<)
	summary: (>>>SUMMARY<<<)
	---

    (>>>POINT<<<)

    >>>TEMPLATE-DEFINITION-SECTION<<<
    ("SUMMARY" "Summary?" "" "" "-- no summary --")
    ("TITLE" "Title?" "" "" "")

Now, to submit a now article, I can do: `C-x t`, type the new folder and filename with the `.md` extension, and type `RET`. Further filling in the prompts for template (`RET`), summary and title is a breeze, and then I have the cursor placed at exactly the right point for starting to blog.

Great stuff.





