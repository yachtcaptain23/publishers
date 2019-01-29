ENV["RAILS_ENV"] ||= "test"
require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "selenium/webdriver"
require "webmock/minitest"
require "chromedriver/helper"
require 'sidekiq/testing'
require 'capybara/rails'
require 'capybara/minitest'

Sidekiq::Testing.fake!

WebMock.allow_net_connect!

Chromedriver.set_version "2.38"

module ActionDispatch
  class IntegrationTest
    # Make the Capybara DSL available in all integration tests
    include Capybara::DSL
    # Make `assert_*` methods behave like Minitest assertions
    include Capybara::Minitest::Assertions
    self.use_transactional_tests = true

    setup do
      WebMock.disable_net_connect!
    end

    teardown do
      WebMock.allow_net_connect!
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end

    def visit_authentication_url(publisher)
      get publisher_url(publisher, token: publisher.authentication_token)
    end
  end
end

Capybara.register_driver "chrome" do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: {
          binary: ENV["CHROME_BINARY"],
          args: %w{headless no-sandbox disable-gpu window-size=1680,1050}
      }.compact,
      loggingPrefs: { browser: 'ALL' }
  )
  driver = Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: capabilities
  )
end

Capybara.default_driver = "chrome"

VCR.configure do |config|
  config.cassette_library_dir = "./test/cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<ENCODED API KEY>") { Rails.application.secrets[:sendgrid_api_key] }
  config.ignore_hosts '127.0.0.1', 'localhost'
  config.allow_http_connections_when_no_cassette = true
  config.default_cassette_options = { match_requests_on: [:method, :uri, :body] }
end

require 'minitest/spec'
module ActiveSupport
  class TestCase
    extend Minitest::Spec::DSL
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
    self.use_transactional_tests = true

    # Add more helper methods to be used by all tests here...
  end
end

module Publishers
  module Service
    class PublicS3Service
      def upload(a, b, c) ; end
      def url_expires_in ; end
      def url(a, b)
        'mock'
      end
    end
  end
end


# Load rake tasks here so it only happens one time. If tasks are loaded again they will run once for each time loaded.
require 'rake'
Publishers::Application.load_tasks

# One time test suite setup.
DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean_with(:truncation)

require 'mocha/minitest'
