##LAMBDAS TO SORTS METHODS
##NEEDING DOCUMENTATION

module SortLambdas

  #SORT TWEETS BY USER ALPHABETIC ORDER
  def self.user
    lambda do |tweet1, tweet2|
      tweet1.username <=> tweet2.username
    end
  end

  #SORT TWEETS BY REVERSE USER ALPHABETIC ORDER
  def self.user_reverse
    lambda do |tweet1, tweet2|
      tweet2.username <=> tweet1.username
    end
  end

  #SORT TWEETS BY NEWEST DATE ORDER
  def self.newest
    lambda do |tweet1, tweet2|
      tweet2.date <=> tweet1.date
    end
  end

  #SORT TWEETS BY OLDEST DATE ORDER
  def self.oldest
    lambda do |tweet1, tweet2|
      tweet1.date <=> tweet2.date
    end 
  end
  
end
  
