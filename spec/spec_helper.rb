# frozen_string_literal: true

ENV['JETS_TEST'] = '1'
ENV['JETS_ENV'] ||= 'test'
# Ensures aws api never called. Fixture home folder does not contain ~/.aws/credentails
ENV['HOME'] = "#{`pwd`.strip}spec/fixtures/home"

require 'byebug'
require 'fileutils'
require 'jets'
require 'webdrivers'
require 'os'

abort('The Jets environment is running in production mode!') if Jets.env == 'production'
Jets.boot

require 'jets/spec_helpers'

require 'capybara/rspec'
Capybara.server = :puma, { Silent: true }
Capybara.app = Jets.application
Capybara.default_max_wait_time = 20

# must hard-code port and localhost because of Auth0 callbacks
Capybara.server_port = 8888
Capybara.app_host = 'http://localhost:8888'

Capybara.register_driver :headless_firefox do |app|
  Capybara::Selenium::Driver.load_selenium
  browser_options = ::Selenium::WebDriver::Firefox::Options.new
  browser_options.args << '-headless'
  browser_options.args << '--window-size=1920,1080'
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: browser_options)
end

Capybara.register_driver :headless_chrome do |app|
  Capybara::Selenium::Driver.load_selenium
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.args << '--headless'
    opts.args << '--disable-gpu' if Gem.win_platform?
    # Workaround https://bugs.chromium.org/p/chromedriver/issues/detail?id=2650&q=load&sort=-id&colspec=ID%20Status%20Pri%20Owner%20Summary
    opts.args << '--disable-site-isolation-trials'
    opts.args << '--window-size=1920,1080'
  end
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.javascript_driver = OS.linux? ? :headless_firefox : :headless_chrome

require 'database_cleaner'
require 'faker'
require 'vcr'
require 'timecop'

Timecop.safe_mode = true

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

module Helpers
  def payload(name)
    JSON.parse(File.read("spec/fixtures/payloads/#{name}.json"))
  end
end

RSpec.configure do |config|
  config.include Helpers

  config.before(:suite) do
    SpecMode.mode = :non_feature
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.strategy = example.example.metadata[:type] == :feature ? :truncation : :transaction
    DatabaseCleaner.cleaning do
      example.run
    end
    $show_job_log = false
  end

  $sent_messages = []

  config.before(:each) do
    I18n.locale = I18n.default_locale
    req.reset!
    Faker::UniqueGenerator.clear
    $combiner = MessageCombiner.new
    $forced_error_type = nil
    $sent_messages ||= []
    $sent_messages.clear
    $ext_id = nil
  end

  config.before(:each, type: :feature) do
    SpecMode.mode = :feature
  end

  config.after(:each) do
    SpecMode.mode = :non_feature
    Timecop.return
    Timecop.safe_mode = true
  end

  config.after(:each, type: :feature) do
    SpecMode.mode = :feature
  end

  # Run specs in random order to surface order dependencies.
  # If you find an order dependency and want to debug it, you
  # can fix the order by providing the seed, which is printed
  # after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the
  # `--seed` CLI option.
  # Setting this allows you to use `--seed` to
  # deterministically reproduce test failures related to
  # randomization by passing the same `--seed` value as the
  # one that triggered the failure.
  Kernel.srand config.seed
end

module SpecMode
  @@mode = :non_feature

  def self.mode=(val)
    @@mode = val
  end

  def self.mode
    @@mode
  end
end

def spec_mode
  SpecMode.mode
end

module SessionRequest
  @@session = ActionDispatch::Integration::Session.new(Jets.application)

  def self.session
    @@session
  end
end

# call this to get request helpers that preserve session/cookies
# between reqeusts (i.e. req.post, req.get, etc.)
def req
  SessionRequest.session
end

def maybe?(percent_true=0.5)
  rand <= percent_true
end
