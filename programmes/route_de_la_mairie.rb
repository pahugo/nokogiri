require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rubocop'

def get_all_the_urls_of_val_doise_townhalls(dpt_name)
  page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/#{dpt_name}"))
  extract_a = page.css('a.lientxt') #extrait le contenu de toutes les balises a.lientxt
  @size = extract_a.size 
  puts 'Les url ont été extraites, merci de patienter le temps de tout parcourir et de vous donner les e-mails'
  url_array = [] #crée une array vide
  for i in (0...@size) do  #crée une boucle de 0 au nombre de a.lientxt retournés
    extract_url = extract_a[i]['href'] # recherche le texte affiché sur le site des balises href 
    extract_url[0] = 'http://annuaire-des-mairies.com' #remplace le premier caractère (.) par le début de l'url
    url_array << extract_url.to_s #converti le résultat en string et l'ajoute dans l'array
  end
  return url_array #renvoie l'array d'url à la prochaine méthode
end

def get_the_email_of_a_townhal_from_its_webpage(url) #extrait les url
  emails_array = []
  name_array = []
  @j = 0

  #extrait le contenu de la 7eme balise td (e-mail) ainsi que le titre de la page (commune) pour toutes les url
  url.each do |lien|
    page = Nokogiri::HTML(open(lien))  
    emails_array << page.css('td')[7].text #et les range dans un array
    name_array << page.css('div.col-md-12 h1').text
    in_progress #appelle la méthode in_progress 
  end
  puts '-' * 10
  puts 'Traitement terminé'
  display_results(name_array, emails_array)
end

#affiche une barre de progression pour être sûr que le programme tourne même quand le site est très lent
def in_progress 
  @j += 1
  print '>' if (@j % 2).zero?
  print 'Encore un peu de patience' if @j == @size / 2
  print 'On y est presque !' if @j == @size * 8 / 10
end

def display_results(name_array, emails_array) #affiche le résultat avec choix du formatage par l'utilisateur
  loop do
    puts '-' * 10
    puts 'Afficher le hash en format brut (B), stylisé (S), ou quitter (Q) ?'
    print '>'
    choice = gets.chomp.downcase
    break if choice == 'q'
    emails_hash = Hash[name_array.zip emails_array] #combine les deux array pour former un hash
    if choice == 's'
      emails_hash.each do |k, v|
      puts "#{k} : #{v}"
      puts '-' * 10
      end
    else puts emails_hash
    end
  end
end

def perform
  get_the_email_of_a_townhal_from_its_webpage(get_all_the_urls_of_val_doise_townhalls('val-d-oise'))
end
perform
