require 'erb'
require 'config/accelerator/accelerator_tasks'
 
set :application, "freethinking_isdangero_us" #matches names used in smf_template.erb
set :repository,  "svn://76.21.41.29:3001/freethinking_blog"

set :scm_command, "/opt/local/bin/svn"
set :local_scm_command, :default

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/freethinking.isdangero.us/#{application}" # I like this location
 
set :user, 'freethinking.isdangero.us'
 
# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :subversion
 
# keep a cached code checkout on the server, and do updates each time (more efficient)
set :deploy_via, :remote_cache
 
# Set the path to svn and rake if needed(Does not seem to be necessary on the newpkgsrc templated accelerators, but if needed change path to /opt/local/bin/ )
set :svn, "/opt/local/bin/svn"
set :rake, "/opt/local/bin/rake"

 
set :domain, '8.17.170.87'
 
role :app, domain
role :web, domain
role :db,  domain, :primary => true
 
set :server_name, "freethinking.isdangero.us"
set :server_alias, "freethinking.isdangero.us"
 
# Example dependancies
depend :remote, :command, :gem
depend :remote, :gem, :mongrel, '>=1.1.4'
depend :remote, :gem, :rake, '>=0.7'
#depend :remote, :gem, :RedCloth, '>=3.0.4'
#depend :remote, :gem, :'mislav-will_paginate', '>=2.3.1'
#depend :remote, :gem, :has_finder, '>=0.1.5'
#depend :remote, :gem, :haml, '>=1.8.2'
 
deploy.task :restart do
  accelerator.smf_restart
  accelerator.restart_apache
end
 
deploy.task :start do
  accelerator.smf_start
  accelerator.restart_apache
end
 
deploy.task :stop do
  accelerator.smf_stop
  accelerator.restart_apache
end
 
after :deploy, 'deploy:cleanup'