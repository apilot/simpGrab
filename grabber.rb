require 'open-uri'
require 'nokogiri'

url = '#####'
#url = '#####'
html = open(url)

doc = Nokogiri::HTML(html)
# woocommerce-LoopProduct-link woocommerce-loop-product__link -- class of link
links = []
g_links = []
b_links = []
nodeset = doc.css('li.product a[href]')
#nodeset = doc.at_css('a[href="goodyear*"]')
links = nodeset.map{|element| element["href"]}.compact
links.each do |goodlinks|
  if goodlinks.include?('goodyear')
    g_links << goodlinks
  else
    b_links << goodlinks
  end
end

######
#######
puts "site has:#{g_links.length} links"
File.open('output.txt', 'w') do |file|
  g_links.each { |x| file.puts(x) }
end
puts "file output created"

url_p = []

File.open('output.txt', 'r') do |file|
  file.each_line { |x| url_p.push(x) }
end
puts "file has: #{url_p.length} links"
url_r = []
url_p.each do |x|
  url_r << url + x
end
File.open('output_r.txt', 'w') do |file|
  url_r.each { |x| file.puts(x) }
end
puts "file output created"
#puts url_r.length проверка количества измененных ссылок на страницы
load 'each_product.rb'
File.open('output_r.txt', 'r') do |file|
  file.each_line { |x| url_p.push(x) }
end
puts "file has: #{url_p.length} links"
url_r = []
title_csv = '"Tilda UID";Brand;SKU;Category;Title;Description;Text;Photo;Price;Quantity;"Price Old";Editions;Modifications;"External ID";"Parent UID";Characteristics:Бренд;Characteristics:Пол;"Characteristics:Тип механизма";Characteristics:Ремешок/Браслет;"Characteristics:Материал корпуса";"Characteristics:Класс водонепроницаемости";Characteristics:Стекло;"Characteristics:Способ отображения времени";Characteristics:Стиль;"Characteristics:Цвет браслета/ремешка";"Characteristics:Цвет циферблата";Characteristics:Механизм;"Characteristics:Цвет корпуса";"Characteristics:Отображение даты";Characteristics:Размер;Characteristics:Коллекция;"Characteristics:Страна бренда";"Characteristics:Материал  браслета/ремешка";Characteristics:Гарантия;Characteristics:Корпус;Characteristics:Циферблат;Characteristics:Браслет;Characteristics:Водозащита;Characteristics:Календарь;"Characteristics:Габаритные размеры";Characteristics:Страна;Characteristics:Камень-вставка;Characteristics:Подсветка;"Characteristics:Звуковой сигнал";"SEO title";"SEO descr";"FB title";"FB descr"'
File.open('output_desc.txt', 'a') do |file|
  #info.each { |x| file.puts(x) }
  file.puts(title_csv.chomp)
end
url_p.each do |x|
  puts x
  if url_p != ''
    get_description(x)
  end
end
