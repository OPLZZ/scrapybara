module Scrapybara
  module Loader
    class File
      include Scrapybara::Loader::Base

      def __source
        @path = @options[:input]
        @file = ::File.new(@path)
        @file.read
      end
    end
  end
end
