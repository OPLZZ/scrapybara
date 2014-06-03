 module Scrapybara
  module Runner
    class Scheduled
      include Scrapybara::Runner::Base

      def execute
        ::Sidekiq::Client.push('class' => Scrapybara::Sidekiq::Worker, 'queue' => loader.sidekiq_options[:queue], 'args' => [ 'input' => loader.options[:input] ])
      end

    end
  end
end
