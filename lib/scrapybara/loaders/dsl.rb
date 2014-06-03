module Scrapybara
  module Loader
    module DSL

      attr_accessor :crawler, :options, :crawler_options, :sidekiq_options

      def initialize(options = {})
        @options         = options.clone
        @sidekiq_options = {}
        @crawler_options = {}
      end

      def queue(queue)
        sidekiq_options[:queue] ||= queue
      end

      def repeat_in(seconds)
        sidekiq_options[:repeat_in] ||= seconds
      end

      def retry_on_failure(value)
        sidekiq_options[:retry_on_failure] ||= value
      end

      def driver(driver)
        crawler_options[:driver] ||= driver
      end

      def default_selector(default_selector)
        crawler_options[:default_selector] ||= default_selector
      end

      def log(log)
        crawler_options[:log] ||= log
      end

      def crawl(url, options = {}, &block)
        @crawler = Crawler.new(url, crawler_options.merge(options), &block)
      end

    end
  end
end
