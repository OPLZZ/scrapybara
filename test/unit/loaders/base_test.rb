require 'test_helper'

module Scrapybara
  module Loader
    class BaseTest < Test::Unit::TestCase

      class DummyLoader
        include Scrapybara::Loader::Base
      end
      class StringLoader
        include Scrapybara::Loader::Base

        def __source
          @options[:input]
        end
      end

      context "Custom loader" do

        should "raise exception when #__source method not implemented" do
          assert_raise(NotImplementedError) { DummyLoader.new }
        end

        should "evaluate source when creating new instance" do
          assert_nothing_raised(Exception) do
            loader = StringLoader.new(input: "driver :mechanize")

            assert_equal :mechanize, loader.crawler_options[:driver]
          end
        end

      end

    end
  end
end
