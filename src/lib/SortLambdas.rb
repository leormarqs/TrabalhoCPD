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
  
end
  
