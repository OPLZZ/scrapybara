# Scrapybara

Ruby library providing DSL for describing custom Web scrapers.

## Dependencies

[PhantomJS](http://phantomjs.org/) &mdash; for installation please refer [PhantomJS download](http://phantomjs.org/download.html) page.

## Installation

    git clone https://github.com/OPLZZ/scrapybara.git
    cd scrapybara

... install the required rubygems:

    bundle install

## Usage

You can take a look into [examples](https://github.com/OPLZZ/scrapybara/tree/master/examples) directory for few annotated examples:

* [job-it.rb](https://github.com/OPLZZ/scrapybara/tree/master/examples/job-it.rb)

  This definition goes through [http://www.job-it.cz](http://www.job-it.cz) portal with implemented RDFa markup described in [Recipe for marking-up job posting in RDFa](https://github.com/OPLZZ/data-modelling/wiki/RDFa-Recipe-English), converts identified RDFa markup into JSON-LD and prints job posting title and employment type.

* [idnes.rb](https://github.com/OPLZZ/scrapybara/tree/master/examples/idnes.rb)
  
  This definition prints first two pages of comments of articles listed on main page [http://zpravy.idnes.cz](http://zpravy.idnes.cz)

Each definition can be executed by `scrapybara` binary from [bin](https://github.com/OPLZZ/scrapybara/tree/master/bin) directory

For example:

    bundle exec ./bin/scrapybara examples/job-it.rb

If you run definition in `interactive` mode, code execution is paused for each #fetch, #extract part of the definition in [Pry](https://github.com/pry/pry/) session. When code is paused, you can debug everything you can do in Pry session.

To continue, press `CTRL+D`.

To exit, type `exit!` and press enter.

    bundle exec ./bin/scrapybara examples/job-it.rb --interactive

You can run each definition in browser by overriding Capybara driver from command line.

    bundle exec ./bin/scrapybara examples/job-it.rb --driver selenium

You can combine previous options, so you can have `interactive` mode with `selenium` driver.

    bundle exec ./bin/scrapybara examples/job-it.rb --driver selenium --interactive

You can enable `debug` for `interactive` mode to add even more breakpoints when definition is executed

    bundle exec ./bin/scrapybara examples/job-it.rb --debug --interactive

----

##Funding
<a href="http://esfcr.cz/" target="_blank"><img src="http://novamedia.ff.cuni.cz/system/files/oplzz_banner_en.png" alt="Project of Operational Programme Human Resources and Employment No. CZ.1.04/5.1.01/77.00440."></a>
The project No. CZ.1.04/5.1.01/77.00440 was funded from the European Social Fund through the Operational Programme Human Resources and Employment and the state budget of Czech Republic.
