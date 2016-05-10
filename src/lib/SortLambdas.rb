##LAMBDAS TO SORTS METHODS
##NEEDING DOCUMENTATION

module SortLambdas

  #SORT TWEETS BY USER ALPHABETIC ORDER
  def self.user
    lambda do |tweet1, tweet2|
      tweet1["user"]["screen_name"] <=> tweet2["user"]["screen_name"]
    end
  end

  #SORT TWEETS BY REVERSE USER ALPHABETIC ORDER
  def self.user_reverse
    lambda do |tweet1, tweet2|
      tweet2["user"]["screen_name"] <=> tweet1["user"]["screen_name"]
    end
  end

  #SORT TWEETS BY NEWEST DATE ORDER
  def self.newest
    lambda do |tweet1, tweet2|
      tweet2["created_at"] <=> tweet1["created_at"]
    end
  end

  #SORT TWEETS BY OLDEST DATE ORDER
  def self.oldest
    lambda do |tweet1, tweet2|
      tweet1["created_at"] <=> tweet2["created_at"]
    end 
  end
  
end
  
