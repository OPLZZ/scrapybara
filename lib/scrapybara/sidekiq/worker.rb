module Scrapybara
  module Sidekiq
    class Worker
      include ::Sidekiq::Worker

      def perform(options = {})
        @options = options
        runner.execute
      end

      def loader
        @loader ||= Scrapybara::Loader::File.new(input: @options['input'])
      end

      def runner
        @runner ||= Scrapybara::Runner::Default.new(loader)
      end
    end
  end
end
