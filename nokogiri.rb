require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'certified'
require 'json'

cmd_args = ARGV
$post_to_prod = false;
$telegram_token = nil;
$chat_id = nil;
if (cmd_args.length > 0)
    if (cmd_args[0] == "true")
        $post_to_prod = true
    end
    if (cmd_args[1])
        #Should probably be environment variables
        $telegram_token = cmd_args[1]
        $chat_id = cmd_args[2]
    end
end

$post_url = $post_to_prod ? "https://obscure-inlet-97748.herokuapp.com/" : "http://localhost:3000/"

def bloomberg_trending ()
    page = Nokogiri::HTML(open("https://www.bloomberg.com/canada"))

    stories = page.css('div.story-package-module__stories')

    headlines = []
    urls = []
    stories.each { |story| 
        begin
            headline = story.css('article h3')[0].text
            puts headline
            link = story.css('article h3 a')[0]['href'] # 0 Chooses the first matching element to article h3 a
            puts link
            # Sometimes links will not include protocol and host name. The following fixes this
            protocol = link[0..3]
            if (!(protocol.include? "http"))
                link.prepend("https://www.bloomberg.com")
            end
            urls.push(link)
            headlines.push(headline)
        rescue
            break
        end
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
    time = Time.new
    begin
        response = http.request(request)
    rescue Exception => e
        sendLogToTelegram("#{time}: Did not POST due to exception #{e.message}")
    else
        sendLogToTelegram("#{time}: Response #{response.code} #{response.message}")
    end
end

def sendLogToTelegram(message) 
    base_url = "https://api.telegram.org/bot"
    url = "#{base_url}#{$telegram_token}/sendMessage?chat_id=#{$chat_id}&text=#{message}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = Net::HTTP.get(uri)
    puts "Response #{response}"

end

bloomberg_trending()