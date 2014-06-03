# encoding: utf-8

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

# Define where to start crawling
#
crawl 'http://zpravy.idnes.cz' do

  # Fetch all links by CSS selector '.content .art h3 a' and visit them
  # This selector represents article link on page
  #
  fetch '.content .art h3 a' do

    # You can use Capybara::Session methods
    # For example #title to get current page title
    #
    puts title, '='*100

    # In each article, go to the '.content #discblog-prep-1 a.btn' selector which represents article discussion
    #
    fetch '.content #discblog-prep-1 a.btn' do

      # In discussion click on '.content .moot-line a[href*="time"]' selector, which sorts discussion by time
      #
      fetch '.content .moot-line a[href*="time"]' do

        # Extract selector ".contribution table div.user-text" and pass extracted elements as argument `elements` to the block
        #
        # :follow option means that whole extract process is repeated for all links by CSS selector 'table.ico a.ico-right',
        # but only for depth of 2 links
        #
        # So this example prints 2 pages of user comments for each article listed on main page http://zpravy.idnes.cz
        #
        extract ".contribution table div.user-text", follow: { selector: 'table.ico a.ico-right', max: 2 } do |elements|

          # Print each extracted element on STDOUT
          #
          elements.each do |element|
            puts "  * #{element.text}"
          end

        end

      end
      puts '-'*100

    end

  end
end
