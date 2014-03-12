if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start
end

require 'bundler/setup'

require 'test/unit'
require 'shoulda/context'
require 'turn'
require 'mocha/setup'
require 'webmock'
require 'vcr'
require 'pry'

require 'scrapybara'

VCR.configure do |c|
  c.cassette_library_dir = File.dirname(__FILE__) + '/fixtures/vcr_cassettes'
  c.hook_into :webmock
end
