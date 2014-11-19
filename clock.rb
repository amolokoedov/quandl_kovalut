require 'clockwork'

include Clockwork

def update()
	puts "Downloading rostov rates..."
	puts `ruby kovalut.rb 6101`
	puts "Updating rostov rates..."
	puts `quandl upload upd_SBER_6101.csv`
	puts `quandl upload upd_BKS_6101.csv`
	puts `quandl upload upd_SKB_6101.csv`
	puts `quandl upload upd_AKBARS_6101.csv`
	puts `quandl upload upd_BIN_6101.csv`
	puts "Downloading moscow rates..."
	puts `ruby kovalut.rb 7701`
	puts "Updating moscow rates..."
	puts `quandl upload upd_SBER_7701.csv`
	puts `quandl upload upd_BKS_7701.csv`
	puts `quandl upload upd_SKB_7701.csv`
	puts `quandl upload upd_AKBARS_7701.csv`
	puts `quandl upload upd_BIN_7701.csv`
	puts `ruby cbr.rb | quandl upload`
end

every(30.minutes, 'Updating Rates') { update() }
