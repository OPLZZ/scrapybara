require 'test_helper'

module Scrapybara
  module Runner
    class BaseTest < Test::Unit::TestCase

      class DummyRunner
        include Scrapybara::Runner::Base
      end

      context "Custom runner" do

        should "raise exception when #execute method not implemented" do
          assert_raise(NotImplementedError) { DummyRunner.new(stub).execute }
        end

      end

    end
  end
end
