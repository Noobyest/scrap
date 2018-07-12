require 'open-uri'
require 'nokogiri'
require 'pry'



# Recupere l'email quand on est sur la page de la mairie correspondante
def get_the_email_of_a_townhal_from_its_webpage(page)

  mail_mairie = ''
  page_mairie = Nokogiri::HTML(open(page))
  
  page_mairie.xpath('//td').each do |node|
    mail_mairie = node.text if node.text.include?('@')

  end
  mail_mairie

end

# Recupere l'url des mairies du val d'oise a partir de la page du val d'oise.
def get_all_the_urls_of_val_doise_townhalls(page, accueil)

  mairies95 = []
  url_mairies = Nokogiri::HTML(open(page))
  
  url_mairies.xpath('//a[@class = "lientxt"]').each do |node|

    if node.values[1][0].include?('.')

      mairies95 << accueil + node.values[1][2..-1]

    end

  end
  mairies95

end

def get_all_email_in95_from_scratch(accueil)
  # Combine les deux precedentes methodes

  val_doise = ''
  mail_mairies = []
  page = Nokogiri::HTML(open(accueil))

  page.xpath('//a').each do |node|
    val_doise = accueil + node.values[1] if node.text.include?("95 | Val-d'Oise")

  end

  get_all_the_urls_of_val_doise_townhalls(val_doise, accueil).each do |url|
    mail_mairies << get_the_email_of_a_townhal_from_its_webpage(url)

  end
  mail_mairies

end

puts get_all_email_in95_from_scratch('http://annuaire-des-mairies.com/')