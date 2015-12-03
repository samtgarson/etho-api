source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
gem 'mongoid', '~> 5.0.0'
gem 'rails-api'
gem 'instagram'
gem 'jwt'
gem 'color'
gem 'colorscore'

gem 'rails_12factor', group: :production

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rspec_junit_formatter', '0.2.2'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'rubocop'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'webmock'
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'rspec-rails', '~> 3.0'
  gem 'faker', git: 'https://github.com/stympy/faker.git'
end
