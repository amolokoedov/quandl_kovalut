# encoding: UTF-8

require "nokogiri"
require 'open-uri'


currency = 'R01235'
download_whole_history = ARGV[0] == "whole"


to = Time.now.utc
from = download_whole_history ? Time.mktime(1970, 1, 1) : to - 5 * 24 * 60 * 60

url = "http://www.cbr.ru/currency_base/dynamics.aspx?VAL_NM_RQ=#{currency}&date_req1=#{from.day}.#{from.month}.#{from.year}&date_req2=#{to.day}.#{to.month}.#{to.year}&rt=1&mode=1"
doc = Nokogiri::HTML(open(url))

puts "code: CBR_USD"
puts "name: Central Bank Of Russia - official USD exchange rate"
puts "description: Central Bank Of Russia - official USD exchange rate"
puts "--"
doc.css('table.data tr').each do |row|
	row = row.css('td')
	if row.size == 3 
		time = row[0].content
		# time = DateTime.strptime(time, '%d.%m.%Y %H:%M')
		# time_key = time.strftime('%Y-%m-%d')
		rate = row[2].content.sub(/,/,'.')
		puts "#{time},#{rate}"
	end
end
