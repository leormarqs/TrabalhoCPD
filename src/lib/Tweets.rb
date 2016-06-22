class Tweet

  attr_accessor :username
  attr_accessor :hashtags
  attr_accessor :text
  attr_accessor :date

  # Define a new tweet object
  def initialize(tweet=nil)
    unless tweet == nil
      @username = truncate_bytes tweet["user"]["screen_name"].to_s
      @hashtags = truncate_bytes parse_hashtags(tweet["entities"]["hashtags"])
      @text = truncate_bytes "#{tweet["text"]} "
      @date = truncate_bytes tweet["created_at"]
    else
      @username = nil
      @hashtags = nil
      @text = nil
      @date = nil
    end
  end

  # Print a tweet object
  def print
    date = @date.split
    day = "#{date[2]}-#{date[1]}-#{date[5]}"
    hour = "#{date[3]} (UTC)"
    puts "@#{@username.split.join} (#{day} #{hour}):\n\t#{@text.split.join(" ")}\n\t#{@hashtags.split.join(" ")}"
    #puts "#{@username}\n#{@hashtags}\n#{@text}\n#{@date}\n\n"
  end

  private #Private methods of this class

  # Parse hashtags to an new tweet
  def parse_hashtags(hashtags)
    hashs = Array.new
    hashtags.each do |ht|
      hashs << ht["text"].to_s
    end
    hashs.join(" ")
  end
end

def truncate_bytes(str)
  current_size = str.bytes.count
  truncate_size = 512 - current_size - 1
  str + (" " * truncate_size)
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

# Make the inverse file of hashtags and write on disk
def write_hash_file(tweets)
  count   = 0
  invFile = Hash.new([])

  tweets.each do |t|
    
    t.hashtags.split.each do |h|
      
      invFile[h.intern] += [count]
      invFile[h.intern].uniq!
      
    end
    count += 1
  end

  File.open("./files/invHash.bin","wb") do |f|
    f.write(Marshal.dump(invFile))
  end
end

#Read an index file for hashtags
def read_hash_file
  invFile = File.open("./files/invHash.bin","rb") do |f|
    Marshal.load(f.read)
  end

  invFile
end

# Make the inverse file of username
def write_user_file(tweets)
  count   = 0
  invFile = Hash.new([])

  tweets.each do |t|
    t.username.split.each do |un|
      invFile[un.intern] += [count]
      invFile[un.intern].uniq!
    end
    count += 1
  end
  
  File.open("./files/invUser.bin","wb") do |f|
    f.write(Marshal.dump(invFile))
  end
end

#Read an index file for users
def read_user_file
  invFile = File.open("./files/invUser.bin","rb") do |f|
    Marshal.load(f.read)
  end

  invFile
end

# Make the inverse file of texts
def write_text_file(tweets)
  count   = 0
  invFile = Hash.new([])

  tweets.each do |t|    
    (t.text.split(%r{\,(?=[\ ]) |\.(?=[\ ]) |\:(?=[\ ])|\!(?=[\ ])|\?(?=[\ ])| \s*})).each do |word|
      if word != ""
        invFile[word.intern] += [count] 
        invFile[word.intern].uniq!
      end
    end
    count += 1
  end
  
  File.open("./files/invText.bin","wb") do |f|
    f.write(Marshal.dump(invFile))
  end
  
end

#Read an index file for text
def read_text_file
  invFile = File.open("./files/invText.bin","rb") do |f|
    Marshal.load(f.read)
  end
  invFile
end

#write on a binary file an array of tweets
def write_file(path, tweets)
  File.open("#{path.to_s}_len.bin","wb") do |f|
    f.write([tweets.length].pack("V"))
  end
  
  File.open(path.to_s, "wb") do |f|
    tweets.each do |t|
      f.write([t.username, t.hashtags, t.text, t.date].pack("Z*Z*Z*Z*"))
    end
  end
end

#Read from a binary file, one single tweet
def read_one_from_file(path,position)

  pos = position
  
  u = IO.binread(path.to_s, 512,pos) {|f| f.read}
  h = IO.binread(path.to_s, 512,(pos+512)) {|f| f.read}
  t = IO.binread(path.to_s, 512,(pos+1024)) {|f| f.read}
  d = IO.binread(path.to_s, 512,(pos+1536)) {|f| f.read}

  tweet = Tweet.new
  
  tweet.username = u.unpack("Z*").join.split.join(" ")
  tweet.hashtags = h.unpack("Z*").join.split.join(" ")
  tweet.text     = t.unpack("Z*").join.split.join(" ")
  tweet.date     = d.unpack("Z*").join.split.join(" ")

  tweet
end

#Read from a binary file, all saved tweets
def read_all_from_file(path)
  max = File.open("#{path.to_s}_len.bin","rb") do |f|
    f.read.unpack("V")[0]
  end
  
  tweets = Array.new
  all =*(0 .. max-1)
  
  all.each do |pos|
    tweets << read_one_from_file(path, (pos*2048))
  end

  tweets

end  
