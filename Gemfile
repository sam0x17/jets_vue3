# frozen_string_literal: true

source 'https://rubygems.org'

gem 'jets'
gem 'zeitwerk', '~> 2.4.0'

# Include jetpacker if you are building html pages
gem 'jetpacker'

# Include pg gem if you are using ActiveRecord, remove next line
# and config/database.yml file if you are not
gem 'pg', '~> 1.2.3'

gem 'activerecord-postgres_enum'
gem 'awesome_print'
gem 'dotenv'

# development and test groups are not bundled as part of the deployment
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'erb_lint', require: false
  gem 'os'
  gem 'pry'
  gem 'puma'
  gem 'rack'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'shotgun'
  gem 'timecop'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'rspec' # rspec test group only or we get the "irb: warn: can't alias context from irb_context warning" when starting jets console
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webdrivers'
  gem 'webmock'
end
