require 'clockwork'

include Clockwork

def update()
	puts "Downloading rostov rates..."
	puts `ruby kovalut.rb 6101`
	puts "Updating rostov rates..."
	puts `quandl upload upd_SBER_6101.csv`
	puts "Downloading moscow rates..."
	puts `ruby kovalut.rb 7701`
	puts "Updating moscow rates..."
	puts `quandl upload upd_SBER_7701.csv`
end

every(1.minutes, 'Updating Rostov Rates') { update() }
