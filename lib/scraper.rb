require 'open-uri'
require 'pry'
require 'nokogiri'
class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
# binding.pry
    # name = doc.css(".student-card").first.css("h4").text
    # location = doc.css(".student-card").first.css("p").text
    # profile_url = doc.css(".student-card a").first.attr("href")
    students = []
    s_cards = doc.css(".student-card")
    s_cards.collect do |s_info|
      students << {
        :name => s_info.css("h4").text,
        :location => s_info.css("p").text,
        :profile_url => s_info.css("a").attr("href").text
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
# binding.pry
    s_attr = {}
    doc.css(".social-icon_container a").collect do |s_links|
      case
      when s_links.css("href").text.include?("twitter")
        s_attr[:twitter] = s_links.css("href").text
      when s_links.css("href").text.include?("linkedin")
        s_attr[:linkedin] = s_links.css("href").text
      when s_links.css("href").text.include?("github")
        s_attr[:github] = s_links.css("href").text
      else
        s_attr[:blog] = s_links.css("href").text
      end
    end
      s_attr[:profile_quote] = doc.css(".profile_quote").text
      s_attr[:bio] = doc.css(".description-holder p").text
      s_attr
  end

end
