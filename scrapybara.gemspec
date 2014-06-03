# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scrapybara/version'

Gem::Specification.new do |spec|
  spec.name          = "scrapybara"
  spec.version       = Scrapybara::VERSION
  spec.authors       = ["Vojtech Hyza"]
  spec.email         = ["vhyza@vhyza.eu"]
  spec.summary       = %q{[WIP] Ruby library providing DSL for describing custom Web scrapers}
  spec.description   = %q{[WIP] Ruby library providing DSL for describing custom Web scrapers}
  spec.homepage      = "https://github.com/oplzz/scrapybara"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capybara"
  spec.add_dependency "capybara-mechanize"
  spec.add_dependency "selenium-webdriver"
  spec.add_dependency "poltergeist"
  spec.add_dependency "sinatra"
  spec.add_dependency "sidekiq"
  spec.add_dependency "ansi"
  spec.add_dependency "pry"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rdf"
  spec.add_development_dependency "rdf-rdfa"
  spec.add_development_dependency "json-ld"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "shoulda-context"
  spec.add_development_dependency "turn"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "simplecov"
end
