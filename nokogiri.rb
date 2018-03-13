require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'certified'


def bloomberg_trending ()
    page =  Nokogiri::HTML(open("https://www.bloomberg.com/canada"))

    puts page.class 
    #puts page.css('ul.top-news-v3__stories li')[0].css('article h1').text
    #puts page.xpath("//ul[@class='top-news-v3__stories']")
    stories = page.css('ul.top-news-v3__stories li')
    stories.each { |story| 
        puts story.css('article h1').text
    }
end

bloomberg_trending()