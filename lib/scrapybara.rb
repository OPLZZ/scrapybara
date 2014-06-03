require 'sidekiq'
require 'capybara'
require 'capybara/poltergeist'
require 'capybara/mechanize'

require 'numeric/time'

require 'scrapybara/fetcher'
require 'scrapybara/extractor'
require 'scrapybara/crawler'
require 'scrapybara/sidekiq/worker'

require 'scrapybara/loaders/dsl'
require 'scrapybara/loaders/base'
require 'scrapybara/loaders/file'

require 'scrapybara/runners/base'
require 'scrapybara/runners/default'
require 'scrapybara/runners/scheduled'
require 'scrapybara/runners/interactive'


require 'scrapybara/cli'

require 'scrapybara/version'

module Scrapybara

  Capybara.register_driver :mechanize do |app|
    Capybara::Mechanize::Driver.new('app')
  end

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, timeout: 300, js_errors: false, inspector: true)
  end

  Capybara.configure do |config|
    config.default_driver   = :mechanize
    config.run_server       = false
    config.app              = "" # to avoid this error: ArgumentError: mechanize requires a rack application, but none was given
  end

end
