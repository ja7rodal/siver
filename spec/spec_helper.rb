# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require_relative '../config/environment'
require 'fabrication'
require 'vcr'
require 'webmock'
require 'rack/test'
require 'rspec-html-matchers'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.include Rack::Test::Methods
  config.include RSpecHtmlMatchers

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    # Keep as many of these lines as are necessary:
    with.library :active_record
    with.library :active_model
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixture/cassettes'
  config.hook_into :webmock
  # config.ignore_localhost = true
  # config.configure_rspec_metadata!
end
