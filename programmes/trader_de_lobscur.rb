require 'rubygems'
require 'nokogiri'
require 'open-uri'

def all_the_names #extrait le contenu de toutes les balises a.currency-name-container (nom)
  page = Nokogiri::HTML(open('https://coinmarketcap.com/all/views/all/'))
  page.css('a.currency-name-container')
end

def all_the_prices #extrait le contenu de toutes les balises a.currency-name-container (prix)
  page = Nokogiri::HTML(open('https://coinmarketcap.com/all/views/all/'))
  page.css('a.price')
end

# recherche les textes affiché sur le site , les range dans des array puis les combine dans un hash
def data_in_array(array1, array2)
  name_array = []
  price_array = []
  for i in (0...array1.size) do
    name_array << array1[i].text
    price_array << array2[i].text
  end
  puts name_array.zip(price_array).map { |name, price| { name => price } }
  puts ' '
  puts '-' * 20
end

def timer  #affiche l'heure de la dernière cotation et celle de la prochaine
  time = Time.now
  delay = 3600
  next_cot = time + delay
  puts ">> Dernières cotations aujourd'hui à #{time.localtime.strftime('%H:%M:%S')}, rangées dans un array de hash comme demandé même si je comprends vraiment pas l'intérêt ;)"
  puts '-' * 20
  puts ">> Prochaine actualisation à #{next_cot.localtime.strftime('%H:%M:%S')}."
  sleep(delay) #met le programme en pause
end

def perform
  loop do #on boucle l'appelle des méthodes pour mettre à jour les cotations
    data_in_array(all_the_names, all_the_prices)
    timer
  end
end
perform
