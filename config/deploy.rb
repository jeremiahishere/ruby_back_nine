require 'bundler/capistrano'

set :stages, %w(production)
set :application, "rubyback9.com"
require 'capistrano/ext/multistage'
set :default_stage, 'production'
set :scm, :git
set :repository,  "git@github.com:jeremiahishere/ruby_back_nine.git"


default_run_options[:pty] = true
set :deploy_to, "/srv/www/#{application}"
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true, :user => "ubuntu" }
load 'deploy/assets'