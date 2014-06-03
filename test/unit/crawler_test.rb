require 'test_helper'

module Scrapybara
  class CrawlerTest < Test::Unit::TestCase

    class DummyFetcher   ; attr_accessor :crawler ; def initialize(*args) ; end ; end
    class DummyExtractor ; attr_accessor :crawler ; def initialize(*args) ; end ; end

    context "Crawler" do
      setup do
        @crawler = Crawler.new 'http://www.nytimes.com/'
      end

      should "track visited urls" do
        url = "http://www.google.com"
        @crawler.instance_variable_set(:@visited, [])
        @crawler.session.expects(:visit).with(url)

        @crawler.visit(url)

        assert_equal [url], @crawler.visited
      end

      should "get absolute URL for current page using passed parameters" do
        @crawler.session.expects(:current_url).returns("http://www.nytimes.com/2014/03/18/world/europe/us-imposes-new-sanctions-on-russian-officials.html")
        assert_equal "http://www.nytimes.com/2014/03/18/world/europe/us-imposes-new-sanctions-on-russian-officials.html?page=3", @crawler.__absolute_url("?page=3")
      end

      should "get absolute URI for current page using passed URI" do
        @crawler.session.expects(:current_url).returns("http://www.nytimes.com/2014/03/18/world/europe/us-imposes-new-sanctions-on-russian-officials.html?hp&_r=0")
        assert_equal "http://www.nytimes.com/2014/03/18/world/europe/obamas-statement-on-new-sanctions-against-russia.html?action=click&contentCollection=Europe&region=Footer&module=MoreInSection&pgtype=article&page=1", @crawler.__absolute_url("/2014/03/18/world/europe/obamas-statement-on-new-sanctions-against-russia.html?action=click&contentCollection=Europe&region=Footer&module=MoreInSection&pgtype=article&page=1")
      end

      should "return absolute URL if passed" do
        @crawler.session.expects(:current_url).returns("http://www.nytimes.com/2014/03/18/world/europe/obamas-statement-on-new-sanctions-against-russia.html")
        assert_equal "http://google.com", @crawler.__absolute_url("http://google.com")
      end

      should "get urls for current page using selector and options" do
        selector = ".section-news li a.story-link"
        elements = [ { 'href' => "http://www.nytimes.com/2014/03/18/world/europe/obamas-statement-on-new-sanctions-against-russia.html"     },
                     { 'href' => "http://www.nytimes.com/2014/03/18/world/europe/european-union-ukraine.html"                               },
                     { 'href' => "http://www.nytimes.com/2014/03/18/world/europe/fighting-pollution-paris-imposes-partial-driving-ban.html" } ]


        @crawler.session.stubs(:current_url).returns("http://www.nytimes.com/2014/03/18/world/europe/us-imposes-new-sanctions-on-russian-officials.html?hp&_r=0")
        @crawler.session.expects(:all).with(:css, selector).returns(elements)

        assert_equal elements.map {|e| e['href']}, @crawler.urls(".section-news li a.story-link", {})
      end

      should "have default fetcher" do
        assert_instance_of Fetcher, @crawler.fetcher
      end

      should "have custom fetcher if passed" do
        crawler = Crawler.new 'http://www.nytimes.com/', fetcher: DummyFetcher
        assert_instance_of DummyFetcher, crawler.fetcher
      end

      should "have default extractor" do
        assert_instance_of Extractor, @crawler.extractor
      end

      should "have custom extractor if passed" do
        crawler = Crawler.new 'http://www.nytimes.com/', extractor: DummyExtractor
        assert_instance_of DummyExtractor, crawler.extractor
      end

      should "have default selector" do
        assert_equal :css, @crawler.default_selector
      end

      should "have default driver" do
        assert_equal :mechanize, @crawler.driver
      end

      should "be able to change driver before session is created" do
        assert_nothing_raised(ArgumentError) do
          @crawler.driver = :poltergeist
          assert_equal :poltergeist, @crawler.driver
          assert_instance_of Capybara::Poltergeist::Driver, @crawler.session.driver
        end
      end

      should "not be able to change driver when session is already created" do
        assert_raise(ArgumentError) do
          session = @crawler.session
          @crawler.driver = :poltergeist
        end
      end

      should "have default logger" do
        crawler = Crawler.new 'http://www.idnes.cz', log: true
        assert_respond_to crawler.logger, :info
      end

      should "get selector for capybara based on default_selector" do
        assert_equal [:css, "#title"], @crawler.__normalize("#title")

        @crawler.default_selector = :xpath
        assert_equal [:xpath, "#title"], @crawler.__normalize("#title")
      end

      should "get custom selector for capybara" do
        assert_equal [:xpath, "#title"], @crawler.__normalize(xpath: "#title")
      end

      should "log if logger is set" do
        logger  = stub
        logger.expects(:info).with("message").returns(true)

        crawler = Crawler.new 'http://www.nytimes.com/', logger: logger
        assert crawler.__log("message")
      end

      should "forward all unknown methods to capybara session" do
        @crawler.stubs(:session).returns(mock(title: "RubyGems.org | your community gem host"))

        assert_equal "RubyGems.org | your community gem host", @crawler.title
      end

      should "start processing the definition" do
        @crawler = Crawler.new 'http://www.nytimes.com/' do ; end

        @crawler.expects(:visit).with("http://www.nytimes.com/")
        @crawler.session.driver.expects(:quit)

        @crawler.start
      end

    end
  end
end
