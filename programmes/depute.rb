require 'rubygems'
require 'nokogiri'
require 'open-uri'

#Données récupérées sur https://wiki.laquadrature.net/Contactez_vos_d%C3%A9put%C3%A9s
#Exemple d'un député:
#Gaby Charroux (Bouches-du-Rhône - GDR) : secretariat-charroux@ville-martigues.fr ; gcharroux@assemblee-nationale.fr

def extract #se connecte au site et extrait les données
  page = Nokogiri::HTML(open('https://wiki.laquadrature.net/Contactez_vos_d%C3%A9put%C3%A9s'))
  extract_txt = page.css('li') #extrait le contenu de toutes les balises <li>
  extract_array = [] #crée une array vide
  for i in (0...extract_txt.size) do #crée une boucle de 0 au nombre de <li> retournés
    extract_array << extract_txt[i].text #recherche les texte affiché de la balise <li> et l'ajoute dans l'array
  end
  extract_array.select! { |x| x.include? '@' } #ne conserve que les occurences de l'array qui contiennent un @, permet de supprimer les contenus des <li> qui ne nous intéressent pas
  extract_array.map!(&:lstrip) #lstrip supprime les espaces vides à l'avant de certains noms
end

def transform_and_output(extract_array)
  depname = extract_array.map { |j| j.partition('(').first } #recherche le contenu de chaque string de l'array avant le symbole (, ce qui permet de ne garder que les noms
  first_name = depname.map { |j| j.partition(' ').first }
  last_name = depname.map { |j| j.partition(' ').last.rstrip } #rstrip supprime le dernier espace vide du nom
  email = extract_array.map { |j| j.match(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i).to_s }  #cherche dans chaque occurence la présence d'un e-mail (regex conçu pour les mails) et remplace chaque
  puts last_name.zip(first_name, email).map { |last, first, mail| { nom: last, prenom: first, email: mail } } #array1.zip(array2, array3) permet de créer un array contenant des arrays de type [array1element1, array2element1, array3element1] etc. /.map modifie l'array en transformant chaque array qu'il contient en hash
end

def perform
  transform_and_output(extract)
end
perform
