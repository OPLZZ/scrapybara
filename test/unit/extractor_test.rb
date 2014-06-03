require 'test_helper'

module Scrapybara
  class ExtractorTest < Test::Unit::TestCase
    context "Extractor" do

      setup do
        @session = Capybara.string(fixture_file('comments.html'))
        @crawler = Crawler.new("http://arstechnica.com")

        @crawler.stubs(session: @session)
        @extractor = @crawler.extractor
        @fetcher   = @crawler.fetcher
      end

      context "When extracting" do
        should "return extracted objects to passed block" do
          @extractor.extract ".comment" do |elements|
            assert_equal 5, elements.size
            assert_equal "That image look alike some sort of risk game involving pac-man vs the ghost army...",
                         elements.first.find(".body").text.strip
          end
        end
      end

      context "When following" do

        should "follow passed selector" do
          @session.expects(:current_url).returns("http://arstechnica.com")
          @extractor.expects(:follow).with(['http://arstechnica.com/gadgets/2014/03/trademark-issue-will-cause-30000-worth-of-multimeters-to-be-destroyed/'],
                                           '.comment',
                                           follow: { selector: '.subheading.newer a'})

          @extractor.extract ".comment", follow: ".subheading.newer a" do |elements|
            assert_equal 5, elements.size
          end
        end

        should "follow passed selector selected times" do
          @extractor.expects(:urls).with('#read-more a', follow: {selector: '#read-more a', max: 2}).returns(["http://arstechnica.com/page/2/"])
          @extractor.expects(:urls).with('#read-more a', follow: {selector: '#read-more a', max: 1}).returns(["http://arstechnica.com/page/3/"])
          @extractor.expects(:visit).with("http://arstechnica.com/page/2/")

          @crawler.extract 'h1.heading', follow: { selector: '#read-more a', max: 2 } do |articles|
          end
        end

      end
    end
  end
end
