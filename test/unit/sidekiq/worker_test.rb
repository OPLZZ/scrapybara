require 'test_helper'

module Scrapybara
  module Sidekiq
    class WorkerTest < Test::Unit::TestCase
      context "Sidekiq worker" do

        should "run crawler" do
          loader = stub
          runner = mock(:execute)
          job    = Scrapybara::Sidekiq::Worker.new
          Scrapybara::Loader::File.expects(:new).with(input: '/path/to/file').returns(loader)
          Scrapybara::Runner::Default.expects(:new).with(loader).returns(runner)

          job.perform('input' => '/path/to/file')
        end

      end
    end
  end
end
