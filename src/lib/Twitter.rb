# coding: utf-8
require 'oauth'
require 'json'


class Twitter

  #Last requisition to Twitter API
  $last_api_requisition ||= nil
  
  # All requests will be sent to this server.
  @@baseurl = "https://api.twitter.com"
  # Verify credentials address
  @@verify = URI("#{@@baseurl}/1.1/account/verify_credentials.json")  
  #Get the tweets of a specific user
  @@user_timeline = "#{@@baseurl}/1.1/statuses/user_timeline.json"
  #Get the home timeline of authenticated user
  @@home_timeline = "#{@@baseurl}/1.1/statuses/home_timeline.json"

 
  def initialize(file)
    tokens = read_tokens(file)
    @consumer_key = OAuth::Consumer.new(
      tokens["consumer_key"],
      tokens["consumer_secret"])
    @access_token = OAuth::Token.new(
      tokens["access_token"],
      tokens["access_secret"])
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
  def auth_status
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

  #Returns a collection of the most recent tweets posted by the user indicated by 'user'
  def user_timeline user, count, since_id=nil
    #Refresh the last api requisition time
    $last_api_requisition = Time.now
    
    #Make a url with the query format to get a user timeline
    unless since_id
      query = URI.encode_www_form "screen_name" => user.to_s,
                                   "count" => count
    else
      query = URI.encode_www_form "screen_name" => user.to_s,
                                  "count" => count,
                                  "since_id" => since_id
    end
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
    
    # Parse and return the Tweets if the response code was 200
    timeline = JSON.parse response.body if response.code == '200'
  end


  #Get the 'count' last tweets from the authenticated user home_timeline
  def home_timeline  count, since_id=nil
    #Refresh the last api requisition time
    $last_api_requisition = Time.now

    #Make a url with the query format to get the home timeline
    unless since_id
      query = URI.encode_www_form "count" => count
    else
      query = URI.encode_www_form "count" => count,
                                  "since_id" => since_id
    end
    url   = URI("#{@@home_timeline}?#{query}")
    
    #Set up HTTP with SSL (Required by Twitter)
    http             = Net::HTTP.new url.host, url.port
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    
    #Issue the request.
    get              = Net::HTTP::Get.new url
    get.oauth! http, @consumer_key, @access_token
    http.start
    response         = http.request get

    # Parse the Tweets if the response code was 200
    timeline = JSON.parse response.body if response.code == "200"

  end


  # Print texts from a list of Tweets
  def print_tweets tweets
    tweets.each do |tweet|
      date = tweet["created_at"].split(" ")
      day = "#{date[2]}-#{date[1]}-#{date[5]}"
      hour = "#{date[3]} (UTC)"
      puts "@#{tweet["user"]["screen_name"]} (#{day} #{hour}): \n\t#{tweet["text"]}\n\n"
    end
  end


end #End of Twitter Class
