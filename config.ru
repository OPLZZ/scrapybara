$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require File.expand_path('../lib/scrapybara',  __FILE__)

require 'sidekiq/web'

if ENV['SIDEKIQ_USERNAME'] && ENV['SIDEKIQ_PASSWORD']

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end

end

run Sidekiq::Web
