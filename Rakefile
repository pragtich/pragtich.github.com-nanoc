begin
  require 'nanoc3/tasks'
rescue LoadError
  require 'rubygems'
  require 'nanoc3/tasks'
end

# Required gem for nanoc-git: pushing to github
require 'nanoc-git/tasks'

desc "Initialise sitecopy."
task :init do
  system 'sitecopy -r sitecopy/sitecopyrc -p sitecopy -i homedrive.ziggo.nl'
end

desc "Upload to Web via sitecopy."
task :upload do
  system 'sitecopy  -r sitecopy/sitecopyrc -p sitecopy -u homedrive.ziggo.nl'
end

desc "compile and upload."
task :co do
  system 'nanoc co && sitecopy  -r sitecopy/sitecopyrc -p sitecopy -u homedrive.ziggo.nl'
end
