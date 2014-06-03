module Scrapybara
  class Extractor
    extend Forwardable

    attr_reader    :crawler
    def_delegators :@crawler, :session, :__log, :__normalize, :urls, :visit, :visited?

    def initialize(crawler)
      @crawler = crawler
    end

    def extract(selector, options={}, &block)
      options[:follow] = { selector: options[:follow] } if options[:follow] && options[:follow].is_a?(String)

      follow_urls = options[:follow] ? urls(options[:follow][:selector], options) : []

      block.call session.all(*__normalize(selector))

      follow(follow_urls, selector, options, &block) unless follow_urls.empty?
    end

    def follow(urls, extract_selector, options, &block)
      urls.each do |url|
        if options[:follow][:max].nil? || (options[:follow][:max] && options[:follow][:max] - 1 > 0)
          unless visited?(url)
            visit(url)
            options[:follow][:max] -= 1 if options[:follow][:max]
            extract(extract_selector, options, &block)
          end
        end
      end
    end

  end
end
