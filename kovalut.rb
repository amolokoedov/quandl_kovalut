require "nokogiri"
require 'rest-open-uri'

t = Time.now.utc

data = Hash.new
city = ARGV[0]
# 6101 - rostov
# 7701 - moscow

begin
	body = "hd-day=#{t.day}&hd-month=#{t.month}&hd-year=#{t.year}&hd-hour=59&hd-min=59&hl-day=7&hl-hour=0&hl-min=0&ht=1&op=5"
	puts t.to_s
	t = t - 5*60*60*24

	doc = Nokogiri::HTML(open('http://kovalut.ru/history.php?kod=' + city.to_s, 
		:method => :post, 
		:body => body, 
		"Content-Type" => "application/x-www-form-urlencoded"))

	count = 0

	doc.css('.tb-k tr.wi', '.tb-k tr.wigr1').each do |row|
		row = row.css('td')
		bank = row[0].content.sub(/([^\*]*)\*.*/,'\1')
		time = row[5].content
		time = DateTime.strptime(time, '%d.%m.%Y %H:%M')
		time_key = time.strftime('%Y-%m-%d')
		usd_buy = row[1].content
		usd_sell = row[2].content
		eur_buy = row[3].content
		eur_sell = row[4].content
		if usd_buy != '-' and usd_sell != '-' and eur_buy != '-' and eur_sell != '-'
			if not data.has_key?(bank)
				data[bank] = Hash.new
			end
			if not data[bank].has_key?(time_key)
				data[bank][time_key] = [usd_buy, usd_sell, eur_buy, eur_sell]
			end
			count += 1
		end
	end

end while count > 0

data.each do |bank, prices| 
	code = bank + '_' + city.to_s 
	filename = '_' + code + '.csv'
	puts 'writing ' + filename + '...'
	File.open(filename, 'w') { |file|
		file.puts 'code: ' + code
		file.puts 'name: Exchange Rates for ' + bank
		file.puts 'description: Exchange Rates for ' + bank
		file.puts '-----'
		file.puts 'Time,USD_BUY,USD_SELL,EUR_BUY,EUR_SELL'
		prices.sort.map do |key, val|
			file.puts key + ',' + val.map{|v| v}.join(',')
		end
	}
end
