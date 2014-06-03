require 'test_helper'

module Scrapybara
  module Runner
    class ScheduledTest < Test::Unit::TestCase

      context "Scheduled loader" do

        should "enqueue crawling job" do
          loader  = stub(options: {input: '/path/to/file'}, sidekiq_options: {queue: 'default'})
          ::Sidekiq::Client.expects(:push).with('class' => Scrapybara::Sidekiq::Worker,
                                                'queue' => 'default',
                                                'args'  => [{'input' => '/path/to/file'}])

          runner  = Scrapybara::Runner::Scheduled.new(loader)
          runner.execute
        end

      end

    end
  end
end
