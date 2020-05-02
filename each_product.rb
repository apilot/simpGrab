#require 'open-uri'
#require 'nokogiri'
def get_description(url)
  puts "============= #{url}"
  product_url = 'http://127.0.0.1/goodyearwatches.com/goodyearwatches.com/shop/' + url.chomp
  #url = 'http://goodyearwatches.com/shop/'

  string_cvs =''
  if product_url == ''
    puts "нет адреса, ошибка!!!"
    abort
  else
    prod_html = open(product_url)
  end

  prod_doc = Nokogiri::HTML(prod_html)

  info = []
  title = prod_doc.at_css('h1').inner_html.strip
  puts "Наименование товара: #{title}"
  price = prod_doc.at_css('span.woocommerce-Price-amount').inner_html.strip
  price = price.strip[0..2]
  puts "цена: #{price}"
  img_link_name = []
  #prod_doc.xpath("//*[@class='attachment-woocommerce_thumbnail']").remove.xpath("//*[img]").each do |link|
  prod_doc.search('img.attachment-woocommerce_thumbnail','img.custom-logo','img.emoji').remove
  prod_doc.search('img').each do |link|
    #puts link.attr('class')
    #puts link
    link_img = link.attr('src')
    if !link_img.include?('opak') && !link_img.include?('100x100') && !link_img.include?('opak2')
      img_link_name << link_img.slice!(33..100)
    end
    #puts link.attr('src')
  end
  puts "наименование картинок товара:#{img_link_name}"

  desc = {}
  counts = 0
  prod_doc.css('div#tab-description p').each do |showing|
    array = []
    showing.search('a').remove
    showing.search('em').remove
    counts += 1
    text = showing.inner_html.strip
    array = text.split(/[:]+/)
    #puts array
    if counts == 1
      name = "Brand"
      text = array[0]
    elsif counts == 2
      name = "Model"
      text = array[0]
    else
      name = array[0]
      text = array[1]
    end
    desc[name] = text.to_s.delete ";"
    #puts counts.to_s

  end
  price_old = price.to_i + price.to_i/100*20
  puts "описание: #{desc}"
  string_cvs += "#{desc['EAN']};#{desc['Brand']};#{desc['EAN']};;#{title};#{desc['Functions']};;http://orbita64.ru/img/#{img_link_name[0]};#{price};;#{price_old.to_s};;;;;#{desc['Brand']};;#{desc['Movement']};Ремешек ширина: #{desc['Band width (at widest point)']}, Ремешек длина:#{desc['Band length (max. wrist size)']};#{desc['Case']};#{desc['Water resistance']};#{desc['Glass']};Аналоговый;;;;#{desc['Movement']} - #{desc['Movement model']};;;#{desc['Case Size (diameter of the case x height of the case)']};;;;1 год;;;;;;#{desc['Case Size (diameter of the case x height of the case)']};"
  info << title
  info << img_link_name
  info << desc
  File.open('output_desc.txt', 'a') do |file|
    #info.each { |x| file.puts(x) }
    file.puts(string_cvs.chomp)
  end
  puts "file desc output created"
  puts "======================#{string_cvs}"
end
