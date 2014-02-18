source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

#gem 'bootstrap-sass'
#gem 'twitter-bootstrap-rails'
gem 'will_paginate', '3.0.pre2'
gem 'jquery-rails'

group :development, :test do
  gem 'sqlite3'	
  gem 'rspec-rails'
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end

group :development do
  gem 'annotate', '2.4.0'
  gem 'faker', '0.3.1'
end

group :test do
  gem 'capybara'  
  gem 'spork', '0.9.0.rc8'
  gem 'factory_girl_rails', '4.2.1'
  # gem 'autotest', '4.4.6'
  # gem 'autotest-rails-pure', '4.1.2'
  # gem 'autotest-fsevent', '0.2.4'
  # gem 'autotest-growl', '0.2.9'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.3.0'
end

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
