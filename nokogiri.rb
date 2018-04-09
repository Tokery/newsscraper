require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'certified'
require 'json'

cmd_args = ARGV
$post_to_prod = false;
if (cmd_args.length > 0 && cmd_args[0] == "true" )
    $post_to_prod = true
end
$post_url = $post_to_prod ? "https://obscure-inlet-97748.herokuapp.com/" : "http://localhost:3000/"

def bloomberg_trending ()
    page = Nokogiri::HTML(open("https://www.bloomberg.com/canada"))

    stories = page.css('ul.top-news-v3__stories li')

    headlines = []
    urls = []
    stories.each { |story| 
        headline = story.css('article h1').text
        link = story.css('article h1 a')[0]['href'] # For some reason [0] is required
        # Sometimes links will not include protocol and host name. The following fixes this
        protocol = link[0..3]
        if (!(protocol.include? "http"))
            link.prepend("https://www.bloomberg.com")
        end
        urls.push(link)
        headlines.push(headline)
    }
    puts "Done bloomberg collection"
    sendDataToApi(headlines, urls)
end

def newyorktimes_trending ()
end

def cbc_trending()
end

def sendDataToApi (stories, urls)
    uri = URI.parse($post_url)
    http = Net::HTTP.new(uri.host, uri.port)
    if ($post_to_prod) 
        http.use_ssl = true
    end
    request = Net::HTTP::Post.new("/articles")
    request.add_field('Content-Type', 'application/json')
    request.body = {'article' => {'title' => 'Bloomberg', 'text' => stories.to_json, 'url' => urls.to_json}}.to_json
    begin
        response = http.request(request)
    rescue Exception => e
        puts "Did not POST due to exception"
        puts e.message
    end
    puts "Response #{response.code} #{response.message}"
end

bloomberg_trending()