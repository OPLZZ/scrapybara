 module Scrapybara
  module Runner
    class Interactive
      include Scrapybara::Runner::Base

      def initialize(loader, options = {})
        super(loader, options)
        __set_tracing
      end

      def execute
        require 'pry'
        require 'stringio'
        loader.crawler.start
      end

      def __pry_input
        StringIO.new <<-CODE
        if block.source_location[0].include?('eval')

          puts "From: ".ansi(:bold) + "#{loader.options[:input]}", ""
          puts Pry::Code.from_file('#{loader.options[:input]}').with_marker(block.source_location[1]).with_line_numbers.to_s
        end
        CODE
      end

      def __set_tracing
        tracked_event = loader.options[:debug] ? "line" : "call"
        set_trace_func proc { |event, file, line, id, binding, classname|
          if event == tracked_event && \
            ((id == :fetch && classname == loader.crawler.fetcher.class) || (id == :extract && classname == loader.crawler.extractor.class))
            Pry.start binding, :input => __pry_input
          end
        }
      end

    end
  end
end
