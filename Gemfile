# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bcrypt'
gem 'byebug'
gem 'figaro'
gem 'json'
gem 'rake', '~> 12.0'
gem 'rest-client'
gem 'sinatra'
gem 'sinatra-activerecord'
gem 'sinatra-flash'
gem 'sqlite3'

# DRY RB gems
gem 'dry-monads'
gem 'dry-transaction'
gem 'dry-types'
gem 'dry-validation'

group :test do
  gem 'database_cleaner-active_record'
  gem 'fabrication'
  gem 'forgery'
  gem 'rack-test'
  gem 'rspec', '~> 3.0'
  gem 'rspec-html-matchers'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'vcr'
  gem 'webmock'
end

group :production do
 gem 'pg'
end
