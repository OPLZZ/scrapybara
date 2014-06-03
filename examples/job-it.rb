# encoding: utf-8

# Load required libraries
#
require 'rdf'
require 'rdf/rdfa'
require 'json/ld'

# Select driver for capybara
# Implemented drivers:
#
# :mechanize   - driver based on Mechanize gem
# :selenium    - use Firefox, useful to see whats happening
# :poltergeist - use PhantomJs, useful for javascript execution
#
driver           :mechanize

# Select default selector
# Available selectors:
#
# :css   - use CSS selectors
# :xpath - use XPATH selectors
#
default_selector :css

frame = {
  "@type" => "JobPosting",
  "@context" => {
    "@vocab"    => "http://schema.org/",
    "dcterms"   => "http://purl.org/dc/terms/",
    "@language" => "cs"
  }
}

# Define where to start crawling
#
crawl 'http://www.job-it.cz/' do

  # You can use Capybara::Session methods
  # This command click on button 'Hledat'
  #
  click_on 'Hledat'

  # Fetch all links by CSS selector '.content h3 a' and visit them
  # For all visited pages do the passed ruby block
  #
  # :follow option means that whole fetch process is repeated for all links by CSS selector ".pagination .next a"
  #
  fetch '.content h3 a', follow: ".pagination .next a" do

    # Get current page html by calling Capybara::Session#body and add it's RDFa to RDF::Graph instance
    #
    graph  = RDF::Graph.new
    graph << RDF::RDFa::Reader.new(body)

    # Convert to JSON-LD
    #
    jsonld          = MultiJson.load(graph.dump(:jsonld, standard_prefixes: true))
    job_posting     = JSON::LD::API.frame(jsonld, frame)["@graph"].first
    employment_type = job_posting.has_key?("employmentType") ? job_posting["employmentType"] : "Typ pracovního poměru neuveden"

    # Print Job posting title and employment type
    #
    puts "#{job_posting["title"]} - #{employment_type}", '-'*100
  end

end
