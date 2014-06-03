 module Scrapybara
  module Runner
    module Base

      attr_accessor :loader, :options, :logger

      def initialize(loader, options = {})
        @loader  = loader
        @options = options
      end

      def execute
        raise NotImplementedError, "You need to implement #exectute method"
      end
    end
  end
end
