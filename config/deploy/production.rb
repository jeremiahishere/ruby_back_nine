set :branch, "master"
set :rails_env, "production"
set :application, "rubyback9.com"

role :web, "rubyback9.com"                          # Your HTTP server, Apache/etc
role :app, "rubyback9.com"                          # This may be the same as your `Web` server
role :db,  "rubyback9.com", :primary => true        # This is where Rails migrations will run