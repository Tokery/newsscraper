require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'certified'
require 'json'

$post_to_prod = false
$post_url = $post_to_prod ? "https://obscure-inlet-97748.herokuapp.com/" : "http://localhost:3000/"

def bloomberg_trending ()
    page = Nokogiri::HTML(open("https://www.bloomberg.com/canada"))

    stories = page.css('ul.top-news-v3__stories li')

    headlines = []
    stories.each { |story| 
        headline = story.css('article h1').text
        headlines.push(headline)
    }
    puts "Done bloomberg collection"
    sendDataToApi(headlines)
end

def newyorktimes_trending ()
end

def cbc_trending()
end

def sendDataToApi (stories)
    uri = URI.parse($post_url)
    http = Net::HTTP.new(uri.host, uri.port)
    if ($post_to_prod) 
        http.use_ssl = true
    end
    request = Net::HTTP::Post.new("/articles")
    request.add_field('Content-Type', 'application/json')
    request.body = {'article' => {'title' => 'Bloomberg', 'text' => stories.to_json}}.to_json
    begin
        response = http.request(request)
    rescue Exception => e
        puts "Did not POST due to exception"
        puts e.message
    end
    puts "Response #{response.code} #{response.message}"
end

bloomberg_trending()