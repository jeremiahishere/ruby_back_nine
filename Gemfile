source 'http://rubygems.org'

gem 'rails', '3.1.10'
gem 'mysql2'

# authentication
gem 'devise'
gem 'cancan'

# deploy
gem 'capistrano'
gem 'capistrano-ext'

# front end
gem 'formtastic'
gem 'haml-rails'
gem 'jquery-rails'
gem 'kaminari'
gem 'therubyracer'
# assets

# code running
gem 'jquery-rails'
gem 'rubycop'
gem 'trackable_tasks'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'machinist', '>= 2.0.0.beta2'
  gem 'faker'

  gem 'rspec'
  gem 'rspec-rails'
  gem 'shoulda'
end

#deployment
group :production, :staging do
  gem 'unicorn'
end
