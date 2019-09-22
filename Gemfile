source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# For loading environment variables from .env file
gem 'dotenv-rails'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rails-controller-testing'

  # for moching in tests
  gem 'webmock'
  gem 'test-unit'

end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # For live-reload
  gem "guard", ">= 2.2.2", require: false
  gem "guard-livereload", require: false
  gem 'guard-rails', require: false
  gem "rack-livereload"
  gem "rb-fsevent", require: false

  gem 'rails-erd', require: false
  gem 'pry-coolline' # for guard
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# For loading the sb-admin theme
gem 'jquery-rails'
gem 'font-awesome-sass', '~> 4.7.0'

# Pagination
gem 'will_paginate-bootstrap4'

# For user/role management
gem 'devise'
gem 'omniauth-oauth2'
gem 'cancancan'
gem 'rolify'
gem 'rest-client'

# For backoffice
gem 'rails_admin', '~> 1.3'

# For the menu
gem 'simple-navigation', '~> 4.0.5' # For the menu

# For parallel processing
gem 'parallel'

gem 'darwinning' # For genetic algorithms
gem "ai4r" # ditto

gem 'simple_token_authentication', '~> 1.0' # For API authentication

# For coverage tests
gem 'simplecov', require: false, group: :test

gem 'underscore-rails'

gem 'ruby-progressbar'
gem 'upsert'

gem 'rack-mini-profiler', require: false

# For jobs
gem "sidekiq-cron", "~> 0.6.3"
gem 'rufus-scheduler', '~> 3.4.0'

gem 'sidekiq'
gem 'sidekiq-unique-jobs'
gem 'redis-namespace'

# For openstreetmaps
gem 'leaflet-rails'

# For quicker db batch updates
gem 'bulk_insert'

# For filtering the scenarios
gem 'filterrific'

# for k-means clustering
gem 'kmeans-clusterer'

gem 'bootsnap' # Suggested by update to 4.2

gem 'fast_inserter'

