require 'test_helper'

module Scrapybara
  module Runner
    class InteractiveTest < Test::Unit::TestCase

      context "Interactive loader" do

        teardown do
          set_trace_func nil
        end

        should "setup tracing and execute crawler" do
          crawler = Crawler.new("http://arstechnica.com") do
            fetch "selector" do
            end
          end

          Pry.expects(:start).with do |binding, options|
            assert_kind_of Binding, binding
            assert_kind_of StringIO, options[:input]
          end

          crawler.expects(:visit).with("http://arstechnica.com")
          crawler.expects(:urls).with("selector", {}).returns([])
          loader  = stub(options: {input: '/path/to/file'}, crawler: crawler)

          runner  = Scrapybara::Runner::Interactive.new(loader)
          runner.execute
        end

      end

    end
  end
end
