set :branch, "master"
set :rails_env, "production"

role :web, "54.235.68.139"                          # Your HTTP server, Apache/etc
role :app, "54.235.68.139"                          # This may be the same as your `Web` server
role :db,  "54.235.68.139", :primary => true        # This is where Rails migrations will run