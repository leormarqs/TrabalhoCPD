class Tweet

  attr_reader :username
  attr_reader :hashtags
  attr_reader :text
  attr_reader :date

  # Define a new tweet object
  def initialize(tweet)
    @username = "%15s" % tweet["user"]["screen_name"].to_s
    @hashtags = parse_hashtags tweet["entities"]["hashtags"]
    @text = "%141s" % "#{tweet["text"]} "
    @date = "%30s" % tweet["created_at"].to_s
  end

  # Print a tweet object
  def print
    puts "@#{@username.split.join} (#{@date}): \n\t#{@text.split.join(" ")} \n\t#{@hashtags.split.join(" ")}"
  end
  
  private #Private methods of this class

  # Parse hashtags to an new tweet
  def parse_hashtags(hashtags)
    hashs = Array.new
    hashtags.each do |ht|
      hashs << "#{ht["text"]} "
    end
    "%255s" % hashs.join
  end
end

# Parse an array of tweets
def parse_tweets(tweets)
  twts = Array.new 
  tweets.each do |t|
    t1 = Tweet.new t
    twts << t1 
  end
  twts
end

# Print an array of tweets
def print_tweets(tweets)
  tweets.each do |t|
    t.print
    puts "\n"
  end
  true
end

# Make the inverse file of hashtags
def hash_file(tweets)
  count   = 0
  invFile = Hash.new([])

  tweets.each do |t|
    (t.hashtags.split).each do |h|    
      invFile[h.intern] += [count]
    end
    count += 1
  end
  invFile
end

# Make the inverse file of username
def user_file(tweets)
  count   = 0
  invFile = Hash.new([])

  tweets.each do |t|
    (t.username.split).each do |un|    
      invFile[un.intern] += [count]
    end
    count += 1
  end
  invFile
end

# Make the inverse file of texts
def text_file(tweets)
  count   = 0
  invFile = Hash.new([])

  tweets.each do |t|
    
    (t.text.split(%r{\,(?=[\ ]) |\.(?=[\ ]) |\:(?=[\ ])|\!(?=[\ ])|\?(?=[\ ])| \s*})).each do |word|
      invFile[word.intern] += [count] unless word == ""
      invFile[word.intern].uniq!
    end
    count += 1
  end
  invFile
end
