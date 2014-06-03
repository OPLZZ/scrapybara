module Scrapybara
  class Fetcher
    extend Forwardable

    attr_reader    :crawler, :visited
    def_delegators :@crawler, :session, :__log, :__normalize, :urls, :visit, :visited?

    def initialize(crawler)
      @crawler = crawler
    end

    def fetch(selector, options={}, &block)
      options[:follow] = { selector: options[:follow] } if options[:follow] && options[:follow].is_a?(String)

      follow_urls = options[:follow] ? urls(options[:follow][:selector], options) : []

      urls(selector, options).each do |url|
        unless visited?(url)
          visit(url)
          block.arity < 1 ? crawler.instance_eval(&block) : block.call(crawler) if block_given?
        end
      end

      follow(follow_urls, selector, options, &block) unless follow_urls.empty?
    end

    def follow(urls, fetch_selector, options, &block)
      urls.each do |url|
        if options[:follow][:max].nil? || (options[:follow][:max] && options[:follow][:max] - 1 > 0)
          unless visited?(url)
            visit(url)
            options[:follow][:max] -= 1 if options[:follow][:max]
            fetch(fetch_selector, options, &block)
          end
        end
      end
    end

  end
end
