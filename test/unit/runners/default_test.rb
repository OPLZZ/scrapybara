require 'test_helper'

module Scrapybara
  module Runner
    class DefaultTest < Test::Unit::TestCase

      context "Default loader" do

        should "start crawling" do
          crawler = mock(:start)
          loader  = mock(crawler: crawler)

          runner  = Scrapybara::Runner::Default.new(loader)
          runner.execute
        end

      end

    end
  end
end
