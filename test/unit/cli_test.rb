require 'test_helper'
require 'stringio'

module Scrapybara
  class CLITest < Test::Unit::TestCase

    context "CLI" do
      setup do
        Scrapybara::CLI.any_instance.stubs(:__log)
      end

      teardown do
        Scrapybara::CLI.any_instance.unstub(:__log)
      end

      should "parse command-line options" do
        cli = Scrapybara::CLI.new(["--driver", "mechanize", "--queue", "hot", "--interactive", "--schedule", "--debug"])

        assert_equal({debug:  true}, cli.options)
        assert_equal({driver: :mechanize}, cli.crawler_options)
        assert_equal({queue:  :hot}, cli.sidekiq_options)
      end

      should "exit with code 1 if no input is specified" do
        Scrapybara::CLI.any_instance.unstub(:__log)
        cli = Scrapybara::CLI.new(["--driver", "mechanize", "--queue", "hot", "--interactive"])
        cli.logger = Logger.new("/dev/null")
        cli.expects(:__die).with(1)

        cli.validate!
      end

      should "display help and exit" do
        Scrapybara::CLI.any_instance.expects(:exit).with(0)
        STDOUT.expects(:puts)
        cli = Scrapybara::CLI.new(["--help"])
      end

      should "initialize custom logger" do
        Time.stubs(:now).returns(Time.at(1396444370))
        logger = StringIO.new
        cli    = Scrapybara::CLI.new([], logger: logger)

        cli.logger.info "TEST"
        logger.rewind
        assert_equal "\e[2m2014-04-02 15:12:50\e[0m\e[1m | \e[0mTEST\n", logger.read
      end

      should "process user input and execute crawler" do
        Dir.expects(:[]).with("examples/*.rb").returns(["examples/nytimes.rb"])
        loader  = stub
        runner  = mock(:execute)

        cli = Scrapybara::CLI.new(["--driver", "poltergeist", "examples/*.rb"])

        Scrapybara::Loader::File.expects(:new).with do |options|
          assert_equal :poltergeist,          options[:crawler_options][:driver]
          assert_equal "examples/nytimes.rb", options[:input]
        end.returns(loader)

        Scrapybara::Runner::Default.expects(:new).with(loader).returns(runner)

        cli.process_input!
      end

      should "use Scheduled runner when --schedule option selected" do
        Dir.expects(:[]).with("examples/*.rb").returns(["examples/nytimes.rb"])
        loader  = stub
        runner  = mock(:execute)

        cli = Scrapybara::CLI.new(["--driver", "poltergeist", "--queue", "hot", "--schedule", "examples/*.rb"])

        Scrapybara::Loader::File.expects(:new).with do |options|
          assert_equal :hot,                  options[:sidekiq_options][:queue]
          assert_equal :poltergeist,          options[:crawler_options][:driver]
          assert_equal "examples/nytimes.rb", options[:input]
        end.returns(loader)

        Scrapybara::Runner::Scheduled.expects(:new).with(loader).returns(runner)

        cli.process_input!
      end

      should "validate before input processing" do
        cli = Scrapybara::CLI.new(["--driver", "poltergeist", "examples/*.rb"])

        cli.expects(:validate!)
        cli.expects(:process_input!)

        cli.run!
      end

    end

  end
end
