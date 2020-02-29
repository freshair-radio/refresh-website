source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'

gem 'mysql2'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# To upload files

gem 'carrierwave', '~> 1.0'
# Carrierwave dependency (it uses it to resize pics to make thumbnails)
gem 'mini_magick'
# for friendlier URLs
gem 'friendly_id', '~> 5.1.0'
# Validates user emails
gem 'validates_email_format_of'
# Admin interface
gem 'activeadmin', github: 'activeadmin'
# WYSIWYG editor
gem 'ckeditor', github: 'galetahub/ckeditor'
# Datetime picker for ActiveAdmine
gem 'just-datetime-picker'
# For sweet inline icons
gem 'font-awesome-rails'
# For the twitter feed
gem 'twitter'
# Automatically generate 'a' tags from links
gem 'rails_autolink'
# Restrict resources to user with specific roles
gem 'cancancan', '~> 1.10'
# User authentication
gem 'devise'
# To define user roles
gem 'rolify'
# To use environment variables defined in config/application.yml
gem 'figaro'
# To generate pagination
gem 'kaminari'
# HTML parser
gem 'nokogiri'
# Markdown parser
gem 'redcarpet'
# Emails exception alerts to the webmaster
gem 'exception_notification'

# Use Redis adapter for storing broadcast info
# Note: redis-server package must be installed via `apt install redis-server`
gem 'redis'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_girl', "~> 4.0"
  gem 'factory_girl_rails', "~> 4.0"
end

group :development do
  # for deployment and to automate tasks on the server
  gem "capistrano", "~> 3.8"
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-passenger'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-figaro'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
