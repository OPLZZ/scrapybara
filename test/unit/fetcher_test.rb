require 'test_helper'

module Scrapybara
  class FetcherTest < Test::Unit::TestCase
    context "Fetcher" do

      setup do
        @session = stub
        @crawler = Crawler.new("http://www.nytimes.com/")
        @crawler.stubs(session: @session)
        @fetcher = @crawler.fetcher
      end

      context "When fetching" do
        setup do
          @pages = [ { url:   "http://www.nytimes.com/2014/03/18/world/europe/european-union-ukraine.html",
                       title: "Lawmakers in Crimea Move Swiftly to Split From Ukraine" },
                     { url:   "http://www.nytimes.com/2014/03/18/world/europe/obamas-statement-on-new-sanctions-against-russia.html",
                       title: "Obama’s Statement on New Sanctions Against Russia" } ]
        end

        should "visit pages for passed selector" do
          @fetcher.expects(:urls).with("h3 a", {}).returns(@pages.map { |p| p[:url] })
          @fetcher.expects(:visit).with(@pages.first[:url])
          @fetcher.expects(:visit).with(@pages.last[:url])

          @session.expects(:title).twice.returns(@pages.first[:title], @pages.last[:title])

          titles = []

          @fetcher.fetch("h3 a") do
            titles << title
          end

          assert_equal @pages.map {|p| p[:title]}, titles
        end

        should "be able to combine multiple fetching" do
          articles_urls = ["http://arstechnica.com/science/2014/03/ibm-to-set-watson-loose-on-cancer-genome-data/"]
          comments_urls = ["http://arstechnica.com/science/2014/03/ibm-to-set-watson-loose-on-cancer-genome-data/?comments=1"]

          @fetcher.expects(:urls).with("h1.heading", {}).returns(articles_urls)
          @fetcher.expects(:urls).with(".comments-read-link", {}).returns(comments_urls)

          @fetcher.expects(:visit).with(articles_urls.first)
          @fetcher.expects(:visit).with(comments_urls.first)

          @session.expects(:title).twice.returns("IBM to set Watson loose on cancer genome data | Ars Technica", "IBM to set Watson loose on cancer genome data | Comments")

          @fetcher.fetch("h1.heading") do |article|
            assert_equal "IBM to set Watson loose on cancer genome data | Ars Technica", article.title
            article.fetch(".comments-read-link") do |comments|
              assert_equal "IBM to set Watson loose on cancer genome data | Comments", comments.title
            end
          end
        end
      end

      context "When following" do
        setup do
          @article_urls = {
            first_page:  ["http://arstechnica.com/science/2014/03/ibm-to-set-watson-loose-on-cancer-genome-data/"],
            second_page: ["http://arstechnica.com/gadgets/2014/04/google-wireless-google-fiber-cities-could-get-mobile-service-but-to-what-end/"]
          }

          @follow_urls = {
            first_page:  ["http://arstechnica.com/page/2/"],
            second_page: []
          }

          @article_titles = ["IBM to set Watson loose on cancer genome data | Ars Technica",
                            "Google Wireless: Google Fiber cities could get mobile service, but to what end?"]
        end

        should "follow passed selector" do
          @fetcher.expects(:urls).with('h1.heading',   follow: {selector: '#read-more a'}).twice.returns(@article_urls[:first_page], @article_urls[:second_page])
          @fetcher.expects(:urls).with("#read-more a", follow: {selector: '#read-more a'}).twice.returns(@follow_urls[:first_page], @follow_urls[:second_page])

          (@article_urls.values.flatten + @follow_urls.values.flatten).each do |url|
            @fetcher.expects(:visit).with(url)
          end
          @session.expects(:title).twice.returns(*@article_titles)

          titles = []
          @fetcher.fetch 'h1.heading', follow: '#read-more a' do |article|
            titles << article.title
          end
          assert_equal @article_titles, titles
        end

        should "follow passed selector only selected times" do
          @follow_urls[:second_page] = ["http://arstechnica.com/page/3/"]
          @follow_urls[:third_page]  = ["http://arstechnica.com/page/4/"]

          @fetcher.expects(:urls).with('#read-more a', follow: {selector: '#read-more a', max: 2}).returns(@follow_urls[:first_page])
          @fetcher.expects(:urls).with('h1.heading',   follow: {selector: '#read-more a', max: 2}).returns(@article_urls[:first_page])

          @fetcher.expects(:urls).with('#read-more a', follow: {selector: '#read-more a', max: 1}).returns(@follow_urls[:second_page])
          @fetcher.expects(:urls).with('h1.heading',   follow: {selector: '#read-more a', max: 1}).returns(@article_urls[:second_page])

          @fetcher.expects(:visit).with(@article_urls[:first_page].first)
          @fetcher.expects(:visit).with(@follow_urls[:first_page].first)
          @fetcher.expects(:visit).with(@article_urls[:second_page].first)

          @session.expects(:title).twice.returns(*@article_titles)

          titles = []
          @fetcher.fetch 'h1.heading', follow: { selector: '#read-more a', max: 2 } do |article|
            titles << article.title
          end
          assert_equal @article_titles, titles         
        end

      end

    end
  end
end
