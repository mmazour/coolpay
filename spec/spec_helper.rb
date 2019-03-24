# frozen_string_literal: true

require 'bundler/setup'
require 'coolpay'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Coolpay mock API URL
MOCK_API_URL = 'https://private-6d20e-coolpayapi.apiary-mock.com/api'
MOCK_USERNAME = 'your_username'
MOCK_API_KEY = '5up3r$ecretKey!'
