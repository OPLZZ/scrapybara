module Scrapybara
  module Runner
    class Default
      include Scrapybara::Runner::Base

      def execute
        loader.crawler.start
      end

    end
  end
end
