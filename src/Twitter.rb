require 'oauth'
require 'json'

class Twitter
  # All requests will be sent to this server.
  @@baseurl = "https://api.twitter.com"
  # Verify credentials address
  @@verify = URI("#{@@baseurl}/1.1/account/verify_credentials.json")  
  #Get the tweets of a specific user
  @@user_timeline = "#{@@baseurl}/1.1/statuses/user_timeline.json"

  
  def initialize(file)
    @tokens = read_tokens(file)
    @consumer_key = OAuth::Consumer.new(
      @tokens["consumer_key"],
      @tokens["consumer_secret"])
    @access_token = OAuth::Token.new(
      @tokens["access_token"],
      @tokens["access_secret"])
  end

  
  private #Private methods of this class

  
  #Get the keys provided on dev.twitter.com
  #The values must be on a file with the following format:
  #consumer_key YOUR VALUE
  #consumer_secret YOUR VALUE
  #access_token YOUR VALUE
  #access_secret YOUR VALUE   
  def read_tokens file  
    #Initialize a new hash to receiving tokens
    tokens = Hash.new
    
    #Read the file to get the tokens values
    file = File.open file.to_s, "r" do |f|
      while line = f.gets
        words            = line.chomp.split(" ")
        tokens[words[0]] = words[1]
      end
    end
    
    #Return the tokens values on a hash
    tokens
  end

  
  #Parse a response from api (JSON to HASH)
  def parse_response response
    response_body = nil
    
    #Check if the request was successfully attended
    #Then, parse the response body, or puts a erros message on the screen
    if response.code == "200"
      response_body = JSON.parse(response.body)  
    else
      puts "ERROR! Expected a response code of 200 but got #{response.code} instead."
    end
    
    #Return the parsed response body
    response_body
  end

  
  public #Public methods of this class

  
  #Verify the user authentication
  def verify_credentials  
    #Set up HTTP with SSL (Required by Twitter)
    http             = Net::HTTP.new @@verify.host, @@verify.port
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    
    #Issue the request
    get  = Net::HTTP::Get.new @@verify
    get.oauth! http, @consumer_key, @access_token
    http.start
    response         = http.request get

    #Parse the response
    credentials      = parse_response response
  end

  def get_timeline user, count
    #Make a url with the query format to get a user timeline
    query = URI.encode_www_form "screen_name" => user.to_s, "count" => count
    url   = URI("#{@@user_timeline}?#{query}")

    #Set up HTTP with SSL (Required by Twitter)
    http             = Net::HTTP.new url.host, url.port
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    
    #Issue the request.
    get              = Net::HTTP::Get.new url
    get.oauth! http, @consumer_key, @access_token
    http.start
    response         = http.request get
    
    # Print texts from a list of Tweets
    def print_timeline tweets
      tweets.each do |tweet| 
        puts tweet["text"]
      end
    end

    # Parse and print the Tweets if the response code was 200
    print_timeline(JSON.parse response.body) if response.code == '200'
  end

  
end #End of Twitter Class


#SOME TESTES
user = Twitter.new "tokens.txt"
user.get_timeline  "twitterapi", 10 if user.verify_credentials
