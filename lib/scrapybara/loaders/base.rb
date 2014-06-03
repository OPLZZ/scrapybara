module Scrapybara
  module Loader
    module Base
      include Scrapybara::Loader::DSL

      def initialize(options = {})
        super(options)
        @crawler_options = @options.delete(:crawler_options) if @options[:crawler_options]
        @sidekiq_options = @options.delete(:sidekiq_options) if @options[:sidekiq_options]
        instance_eval(__source)
      end

      def __source
        raise NotImplementedError, "You need to implement #__source method returning recipe source"
      end

    end
  end
end
