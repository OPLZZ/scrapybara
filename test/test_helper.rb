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
  c.cassette_library_dir = File.expand_path( Pathname( File.expand_path( 'fixtures/vcr_cassettes', File.dirname(__FILE__) ) ) )
  c.hook_into :webmock
end

class Test::Unit::TestCase

  def fixture_file(path)
    File.read File.expand_path( path, Pathname( File.expand_path( 'fixtures', File.dirname(__FILE__) ) ) )
  end

end
