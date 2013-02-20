require 'bundler/capistrano'

set :stages, %w(production)
set :application, "ruby_back_nine"
require 'capistrano/ext/multistage'
set :default_stage, 'production'
set :scm, :git
set :repository,  "git@github.com:jeremiahishere/ruby_back_nine.git"


default_run_options[:pty] = true
set :deploy_to, "/srv/#{application}"
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true, :user => "ubuntu" }
load 'deploy/assets'






namespace :deploy do
  task :start do
    run "cd #{current_release} && bundle exec unicorn -E #{rails_env} -c /etc/unicorn/rubyback9.com.rb -D"
  end

  task :stop do
    run "kill -QUIT $(cat /var/run/rubyback9.com_unicorn.pid)"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "kill -USR2 $(cat /var/run/rubyback9.com_unicorn.pid)"
  end

  namespace :db do
    task :drop, :roles => :db do
      run "cd #{current_release} && RAILS_ENV=#{rails_env} bundle exec rake db:drop"
    end
    
    task :create, :roles => :db do
      run "cd #{current_release} && RAILS_ENV=#{rails_env} bundle exec rake db:create"
    end
    
    task :migrate, :roles => :db do
      run "cd #{current_release} && RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
    end
    
    task :seed, :roles => :db do
      run "cd #{current_release} && RAILS_ENV=#{rails_env} bundle exec rake db:seed"
    end
  end
end


task :reset_permissions do
  run "sudo chown -R #{user}:#{user} /srv/#{application}.com*"
end

task :call_it_out do
  system "say \"Ruby golf has finished its #{rails_env} deploy\""
end

task :call_it_out_stop do
  system "say \"#{rails_env} deploy stop\""
end

task :call_it_out_start do
  system "say \"#{rails_env} start completed\""
end

namespace :delayed_job do
  desc "Stop the delayed_job process"
  task :stop, :roles => :app do
    run "cd #{current_release}; RAILS_ENV=#{rails_env} script/delayed_job stop"
  end
 
  desc "Start the delayed_job process"
  task :start, :roles => :app do
    run "cd #{current_release}; RAILS_ENV=#{rails_env} script/delayed_job start"
  end
 
  desc "Restart the delayed_job process"
  task :restart, :roles => :app do
    stop
    wait_for_process_to_end('delayed_job')
    start
  end
end

def wait_for_process_to_end(process_name)
  run "COUNT=1; until [ $COUNT -eq 0 ]; do COUNT=`ps -ef | grep -v 'ps -ef' | grep -v 'grep' | grep -i '#{process_name}'|wc -l` ; echo 'waiting for #{process_name} to end' ; sleep 2 ; done"
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(release_path, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :install, :roles => :app do
    run "cd #{release_path} && bundle install --binstubs "

    on_rollback do
      system "say \" something messed up rolling back\""
      if previous_release
        run "cd #{previous_release} && sudo bundle install --binstubs "
      else
        logger.important "no previous release to rollback to, rollback of bundler:install skipped"
      end
    end
  end

  task :bundle_new_release, :roles => :db do
    bundler.create_symlink
    bundler.install
  end
end


task :refresh_sitemap, :roles => :app do
  run "cd #{current_release} && rake RAILS_ENV=#{rails_env} sitemap:refresh:no_ping"
end

after "deploy:stop",    "call_it_out_stop"
after "deploy:start",    "call_it_out_start"

after :deploy do
  call_it_out
end