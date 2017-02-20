require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    index_page = Nokogiri::HTML(html)

    students = []
    index_page.css("div.student-card").each do |student|
      new_student = {
        name: student.css("h4.student-name").text,
        location: student.css("p.student-location").text,
        profile_url: "./fixtures/student-site/" + student.css("a").attribute("href").text
      }
      students << new_student
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile_page = Nokogiri::HTML(html)
    # binding.pry
    profile_hash = {}
    profile_page.css("div.social-icon-container a").each do |social_icon|
      social_media = social_icon.attribute("href").text
      if social_media.include?('twitter')
        profile_hash[:twitter] = social_media
      elsif social_media.include?('github')
        profile_hash[:github] = social_media
      elsif social_media.include?('linkedin')
        profile_hash[:linkedin] = social_media
      else
        profile_hash[:blog] = social_media
      end
    end

    quote = profile_page.css("div.vitals-text-container div.profile-quote").text
    bio = profile_page.css("div.description-holder p").text
    profile_hash[:profile_quote] = quote
    profile_hash[:bio] = bio
    profile_hash
  end

end

Scraper.scrape_index_page('fixtures/student-site/index.html')
