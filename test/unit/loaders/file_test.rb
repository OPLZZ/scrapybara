require 'test_helper'

module Scrapybara
  module Loader
    class FileTest < Test::Unit::TestCase

      context "File loader" do

        should "read and evaluate file" do
          path = "/path/to/definition.rb"
          file = mock(read: "driver :selenium")
          ::File.expects(:new).with(path).returns(file)

          loader = Scrapybara::Loader::File.new(input: path)
          assert_equal :selenium, loader.crawler_options[:driver]
        end

        should "override DSL in file with passed options" do
          path = "/path/to/definition.rb"
          file = mock(read: "driver :selenium")
          ::File.expects(:new).with(path).returns(file)

          loader = Scrapybara::Loader::File.new(input: path, crawler_options: { driver: :poltergeist })
          assert_equal :poltergeist, loader.crawler_options[:driver]
        end

      end

    end
  end
end
