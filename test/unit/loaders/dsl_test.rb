require 'test_helper'

module Scrapybara
  module Loader
    class DSLTest < Test::Unit::TestCase

      class DSLClass
        include Scrapybara::Loader::DSL
        def initialize(source) ; super(); self.instance_eval(source) ; end
      end

      context "Loader DSL" do

        should "setup driver" do
          dsl = DSLClass.new("driver :mechanize")

          assert_equal :mechanize, dsl.crawler_options[:driver]
        end

        should "setup default selector" do
          dsl = DSLClass.new("default_selector :xpath")

          assert_equal :xpath, dsl.crawler_options[:default_selector]
        end

        should "setup logging" do
          dsl = DSLClass.new("log true")

          assert dsl.crawler_options[:log]
        end

        should "setup sidekiq options" do
          dsl = DSLClass.new <<-SOURCE
          queue            :hot
          retry_on_failure true
          repeat_in        1.hour
          SOURCE

          assert_equal :hot, dsl.sidekiq_options[:queue]
          assert_equal 3600, dsl.sidekiq_options[:repeat_in]
          assert dsl.sidekiq_options[:retry_on_failure]
        end

        should "create Crawler if crawl definition presented" do
          dsl = DSLClass.new <<-SOURCE
          crawl "http://arstechnica.com" do
            fetch "h3 a" do
              extract ".comment" do |elements|
              end
            end
          end
          SOURCE

          assert_not_nil dsl.crawler
          assert_equal "http://arstechnica.com", dsl.crawler.url
        end

        should "create Crawler with passed options" do
          dsl = DSLClass.new <<-SOURCE
          driver           :poltergeist
          default_selector :xpath
          log              true

          crawl "http://arstechnica.com" do
            fetch "h3 a" do
              extract ".comment" do |elements|
              end
            end
          end
          SOURCE

          assert_not_nil dsl.crawler
          assert_not_nil dsl.crawler.logger
          assert_equal "http://arstechnica.com", dsl.crawler.url
          assert_equal :poltergeist,             dsl.crawler.driver
          assert_equal :xpath,                   dsl.crawler.default_selector
        end

      end

    end
  end
end
