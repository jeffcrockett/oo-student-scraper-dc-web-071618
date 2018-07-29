require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    html = Nokogiri::HTML(open('./fixtures/student-site/index.html'))
    student_cards = html.css('div.student-card')
    student_cards.each do |student_card|
      obj = {}
      obj[:name] = student_card.css('a div.card-text-container h4.student-name').text
      obj[:location] = student_card.css('a div.card-text-container p.student-location').text 
      obj[:profile_url] = student_card.css('a').attribute('href').value
      students << obj
    end
    # binding.pry
    students 
  end

  def self.scrape_profile_page(profile_url)
    hash = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    social_media = profile_page.css('div.social-icon-container a')
    social_media.each do |media|

      link = media.attribute('href').value

      if link =~ /twitter|facebook|github|linkedin/
      # binding.pry
        url = link.scan(/\w+\.com/)[0][0...-4]
        hash[url.to_sym] = link
      else
        # binding.pry
        hash[:blog] = link 
      end
    end
    hash[:profile_quote] = profile_page.css('div.profile-quote').text 
    hash[:bio] = profile_page.css('body > div > div.details-container > div.bio-block.details-block > div > div.description-holder > p').text
    hash
    # binding.pry
  end

end


