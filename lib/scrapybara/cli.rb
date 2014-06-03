require 'optparse'
require 'ansi/core'
require 'ansi/terminal'

module Scrapybara
  class CLI

    class MissingArgument < ArgumentError ; end;

    DEFAULT_RUNNER_CLASS = Scrapybara::Runner::Default
    DEFAULT_LOADER_CLASS = Scrapybara::Loader::File

    attr_reader   :options, :crawler_options, :sidekiq_options
    attr_accessor :logger

    def initialize(argv = ARGV, options = {})
      @argv            = argv.clone
      @options         = options.clone
      @crawler_options = {}
      @sidekiq_options = {}
      @runner_class    = DEFAULT_RUNNER_CLASS
      @loader_class    = DEFAULT_LOADER_CLASS

      initialize_logger!
      parse!
    end

    def run!
      validate!
      process_input!
    end

    def initialize_logger!
      @logger           = Logger.new(@options[:logger] || STDOUT)
      @logger.formatter = proc do |severity, datetime, progname, msg|
        datetime = datetime.strftime("%Y-%m-%d %H:%M:%S").ansi(:faint)
         "#{datetime}#{" | ".ansi(:bold)}#{msg}\n"
      end
    end

    def validate!
      unless @input
        __log "[!] Missing PATH".ansi(:bold) + "\n\n" + @usage
        __die(1)
      end
    end

    def process_input!
      files = Dir[@input]

      __log "Found #{files.size.to_s.ansi(:bold)} definitions in #{@input.ansi(:bold)}"

      files.each_with_index do |path, i|
        index = ("#" + (i + 1).to_s).ansi(:bold)

        __log "#{index} Running crawler with definition in #{path.ansi(:bold)}..."
        loader = @loader_class.new(options.merge(input: path, sidekiq_options: sidekiq_options, crawler_options: crawler_options))
        runner = @runner_class.new(loader)

        runner.execute
      end
    end

    def parse!
      @parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{"scrapybara".ansi(:bold)} [options] #{"PATH".ansi(:bold)}"

        opts.on("-i", "--interactive", "Run in interactive mode") do |i|
          @runner_class = Scrapybara::Runner::Interactive
        end

        opts.on("--debug", "--debug", "Enable debug mode") do |d|
          @options[:debug] = true
        end

        opts.on("-s", "--schedule", "Schedule crawler job") do |s|
          @runner_class = Scrapybara::Runner::Scheduled
        end

        opts.on("-d", "--driver DRIVER", "Specify driver [mechanize]") do |d|
          @crawler_options[:driver] = d.to_sym
        end

        opts.on("-q", "--queue QUEUE", "Create job in specific queue [default]") do |q|
          @sidekiq_options[:queue] = q.to_sym
        end
      end

      @usage = @parser.to_s

      @parser.on_tail "-h", "--help", "Show help" do
        puts @usage
        __die(0)
      end
      @parser.parse!(@argv)
      @input = @argv.first
    end

    private

    def __log(message)
      logger.info(message)
    end

    def __die(code)
      exit(code)
    end

  end
end
