#SOME TESTES
require './lib/TwitterAPI.rb'
require './lib/Tweets.rb'
require './lib/SortLambdas.rb'

user = TwitterAPI.new "tokens.txt"

timeline =  user.user_timeline "leormarqs", 1 if user.auth_status
#home     = user.home_timeline 5 if user.auth_status

#puts "\n\n\n"
#user.print_tweets home
#home.sort! &SortLambdas.oldest

#puts "\n\n\n"
#user.print_tweets home

timeline1 = parse_tweets timeline
f1 = hash_file timeline1
f2 = user_file timeline1
f3 = text_file timeline1

#print_tweets timeline1

f1.each do |k,v|
    puts "#{k.to_s}  ==>   #{v.to_s}"
end

puts "\n\n\n"

f2.each do |k,v|
    puts "#{k.to_s}  ==>   #{v.to_s}"
end

puts "\n\n\n"

f3.each do |k,v|
    puts "#{k.to_s}  ==>   #{v.to_s}"
end
