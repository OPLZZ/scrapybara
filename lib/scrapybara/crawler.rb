module Scrapybara

  class Crawler

    DEFAULT_FETCHER_CLASS   = Fetcher
    DEFAULT_EXTRACTOR_CLASS = Extractor
    DEFAULT_LOGGER          = lambda do
                                require 'logger'
                                logger = Logger.new(STDERR)
                                logger.progname = 'scrapybara'
                                logger.formatter = proc { |severity, datetime, progname, msg| "#{datetime}: #{msg}\n" }
                                logger
                              end

    attr_reader   :options, :url, :visited
    attr_accessor :extractor, :fetcher, :default_selector, :logger

    def initialize(url, options = {}, &block)
      @options             = options
      @url                 = url
      @driver              = @options[:driver]
      @default_selector    = @options[:default_selector] || :css
      @logger              = @options[:logger]           || (@options[:log] ? DEFAULT_LOGGER.call() : nil)
      @extractor           = (@options[:extractor]       || DEFAULT_EXTRACTOR_CLASS).new(self)
      @fetcher             = (@options[:fetcher]         || DEFAULT_FETCHER_CLASS).new(self)
      @fetcher.crawler   ||= self
      @extractor.crawler ||= self
      @definition          = block
      @visited             = []
    end

    def start
      visit url
      self.instance_eval(&@definition)
    ensure
      session.driver.quit if session.driver.respond_to?(:quit) rescue nil
    end

    def fetch(selector, options = {}, &block)
      fetcher.fetch(selector, options, &block)
    end

    def extract(selector, options = {}, &block)
      extractor.extract(selector, options, &block)
    end

    def visit(url)
      session.visit(url)
      visited << url
    end

    def visited?(url)
      visited.include?(url)
    end

    def driver
      @driver || :mechanize
    end

    def driver=(driver)
      raise ArgumentError, "You can't change driver when session is already created" if driver && @session
      @driver = driver
    end

    def session
      @session ||= Capybara::Session.new(driver)
    end

    def method_missing(method, *args, &block)
      session.send(method, *args, &block)
    end

    def urls(selector, options)
      target = options[:target] || 'href'
      urls   = session.all(*__normalize(selector)).map { |link| __absolute_url(link[target]) }
    end

    def __absolute_url(url)
      URI.join(session.current_url, url).to_s
    end

    def __normalize(selector)
      if selector.is_a?(Hash)
        selector.first
      else
        [ @default_selector, selector ]
      end
    end

    def __log(message)
      @logger.info(message) if @logger
    end

  end

end
