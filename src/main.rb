
#SOME TESTES
require './lib/Twitter.rb'
require './lib/SortLambdas.rb'

user = TwitterAPI.new "tokens.txt"

timeline =  user.user_timeline "leormarqs", 10 if user.auth_status
#home     = user.home_timeline 1 if user.auth_status

puts "\n\n\n"
#user.print_tweets home
#home.sort! &SortLambdas.oldest

#puts "\n\n\n"
#user.print_tweets home

puts "\n\n\n"
timeline1 = parse_tweets timeline;

print_tweets timeline1
