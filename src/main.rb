
#SOME TESTES
require './lib/Twitter.rb'
require './lib/SortLambdas.rb'

user = Twitter.new "tokens.txt"

twitterapi =  user.user_timeline "twitterapi", 10 if user.auth_status
home = user.home_timeline 10 if user.auth_status

puts "\n\n\n"
user.print_tweets home
home.sort! &SortLambdas.oldest

puts "\n\n\n"
user.print_tweets home

puts"\n\n\n"
puts $last_api_requisition

