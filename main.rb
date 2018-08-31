require 'pry'
require 'open-uri'

begin
  start_symbol = File.read('current_symbol.txt').strip
rescue
end


start_symbol = 'INSY'

def get_symbol_info_page(symbol)
  puts "getting #{symbol} from yahoo"
  url = "https://finance.yahoo.com/quote/#{symbol}/profile?p=#{symbol}"
  url = URI.parse(url)
  source = open(url).read
  Net::HTTP.get(url)
end

def find_cannabis_symbol(html)
  html.downcase.index("canna")
end

first_time = true

lines = File.readlines('companylist.csv')
lines.each_with_index do |line, i|
  puts "processing #{i+1} / #{lines.count}"
  next if i==0
  symbol = line.split(',')[0].gsub("\"", "").strip
  puts symbol

  if first_time
    next if symbol != start_symbol 
    first_time = false
  end

  cannabis_symbol = nil

  html = get_symbol_info_page(symbol)
  has_cannabis_in_description = find_cannabis_symbol(html)

  if has_cannabis_in_description
    puts "***Canna FOUND***"
    File.open("cannabis_symbols.txt", 'a') { |file| file.write(symbol + "\n") }
  end
  File.write('current_symbol.txt', symbol)
end


