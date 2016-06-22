# coding: utf-8
require './lib/TwitterAPI.rb'
require './lib/Tweets.rb'
require './lib/SortLambdas.rb'

#Authenticate on Twitter API
user = TwitterAPI.new "tokens.txt"

def read_from_home(user)
  
  hm = user.home_timeline 10 if user.auth_status

  home = parse_tweets hm
  
  write_hash_file home
  write_user_file home
  write_text_file home

  write_file("./files/tweets.bin", home)

  puts "Lido novos tweets!\n\n"

end

def read_from_user(user)
  puts "Forneça o nome de usuario a ser consultado."
  un = gets.chomp
  
  tl = user.user_timeline un.to_s, 10 if user.auth_status

  timeline = parse_tweets tl
  
  write_hash_file timeline
  write_user_file timeline
  write_text_file timeline

  write_file("./files/tweets.bin", timeline)

  puts "Lido novos tweets!\n\n"

end


def search_tweets

  puts "Qual criterio de busca você quer usar?"
  puts "1 - Pesquisa por Hashtags"
  puts "2 - Pesquisa por Username"
  puts "3 - Pesquisa por Palavras do texto"
  
  optThree = gets.chomp

  case optThree
  when "1" then
    hashFile = read_hash_file
    
    puts "Digite a hashtag a ser consultada (Sem #):"
    opt = gets.chomp
    
    consulta = hashFile[opt.intern]

    puts "\nOcorrências encontradas:"
    
    consulta.each do |c|
      read_one_from_file("./files/tweets.bin", (c*2048)).print
      puts "\n"
    end
    
  when "2" then
    userFile = read_user_file
    
    puts "Digite o username a ser consultado (Sem @):"
    opt = gets.chomp
    
    consulta = userFile[opt.intern]

    puts "\nOcorrências encontradas:"
    
    consulta.each do |c|
      read_one_from_file("./files/tweets.bin", (c*2048)).print
      puts "\n"
    end
    
  when "3" then
    textFile = read_text_file

    puts "Digite a palavra a ser consultada:"
    opt = gets.chomp
    
    consulta = textFile[opt.intern]

    puts "\n\nOcorrências encontradas:"
    
    consulta.each do |c|
      read_one_from_file("./files/tweets.bin", (c*2048)).print
      puts "\n"
    end
    
  end
end

def view_tweets
  puts "Qual ordem de exibição você quer usar?"
  puts "1 - Mais recentes primeiro"
  puts "2 - Mais antigos primeiro"

  opt = gets.chomp
  
  tweets = read_all_from_file("./files/tweets.bin")

  puts "Todos os tweets armazenados: \n"
  
  case opt
  when "1"
    tweets.sort! &SortLambdas.newest
    print_tweets tweets
  when "2"
    tweets.sort! &SortLambdas.oldest
    print_tweets tweets
  end
end

def refresh_tweets(user)

  puts "1 - Ler novos tweets da home"
  puts "2 - Ler novos tweets de um usuário específico?"

  opt = gets.chomp
  tweets = read_all_from_file("./files/tweets.bin")

  case opt
  when "1" then
    
    hm = user.home_timeline 10 if user.auth_status

    home = parse_tweets hm

    tl = home + tweets
    tl.uniq!

    
    write_hash_file tl
    write_user_file tl
    write_text_file tl
    
    write_file("./files/tweets.bin", tl)

    puts "Adicionados novos tweets!\n\n"

  when "2" then
    puts "Forneça o nome de usuario a ser consultado."
    un = gets.chomp
  
    tl = user.user_timeline un.to_s, 10 if user.auth_status
    
    timeline = parse_tweets tl

    tl1 = timeline + tweets
    tl1.uniq!
    
    write_hash_file tl1
    write_user_file tl1
    write_text_file tl1
    
    write_file("./files/tweets.bin", tl1)
    
    puts "Adicionados novos tweets!\n\n"
  
  end

end


  
#end

=begin
  
#timeline =  
timeline  = user.home_timeline 100 if user.auth_status

#puts "\n\n\n"
#user.print_tweets home
#home.sort! &SortLambdas.oldest

#puts "\n\n\n"
#user.print_tweets home

timeline1 = parse_tweets timeline

write_hash_file timeline1
write_user_file timeline1
write_text_file timeline1



# Pesquisando  #Rio2016

puts "\n\n\n"



 puts "\n\n\n\n"

write_file "Teste.bin", timeline1
 


consulta = f3["and".intern]



puts "\n\n\n"



#read_one_from_file("Teste.bin", 4096).print
print_tweets read_all_from_file("Teste.bin")



io = File.open("tweets.bin", "wb")
io.write(Marshal.dump timeline1)
io.close

io1 = File.open("tweets.bin", "rb")
tl1 = io1.read
io1.close

tl2 = Marshal.load tl1

print_tweets tl2

=end

puts "Bem-Vindo!"

optOne = nil
optTwo = nil

while optOne != false && optTwo != false
  
  if File.exist?("./files/tweets.bin")
    puts "O que deseja fazer?"
    puts "1 - Pesquisar nos tweets existentes."
    puts "2 - Exibir todos os tweets."
    puts "3 - Ler novos tweets do Twitter."
    puts "4 - Sair."
    
    optOne = gets.chomp
    
    case optOne
    when "1" then search_tweets
    when "2" then view_tweets
    when "3" then refresh_tweets(user)
    when "4" then false
    else nil
    end

  else
    puts "Ainda não existem Tweets Armazenados, o que gostaria de fazer?"
    puts "1 - Ler novos tweets da home"
    puts "2 - Ler novos tweets de um usuário específico?"
    puts "3 - Sair."

    optTwo = gets.chomp

    case optTwo
    when "1" then read_from_home(user)
    when "2" then read_from_user(user)
    when "3" then false
    else nil
    end
  end
end
