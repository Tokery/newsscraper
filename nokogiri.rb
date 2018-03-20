require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'certified'
require 'json'


def bloomberg_trending ()
    page = Nokogiri::HTML(open("https://www.bloomberg.com/canada"))

    puts page.class 
    #puts page.css('ul.top-news-v3__stories li')[0].css('article h1').text
    #puts page.xpath("//ul[@class='top-news-v3__stories']")
    stories = page.css('ul.top-news-v3__stories li')

    headlines = []
    stories.each { |story| 
        headline = story.css('article h1').text
        headlines.push(headline)
    }
    puts "Done bloomberg collection"
    sendDataToApi(headlines)
end

def sendDataToApi (stories)
    uri = URI.parse("http://localhost:3000/")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new("/articles")
    request.add_field('Content-Type', 'application/json')
    request.body = {'article' => {'title' => 'Bloomberg', 'text' => stories}}.to_json
    response = http.request(request)
end

bloomberg_trending()