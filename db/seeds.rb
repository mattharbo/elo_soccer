# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


################################################################################################
############################ Feed the DB with L1 legacy games ##################################
################################################################################################

# require 'net/http'
# require 'json'

# url = 'https://spreadsheets.google.com/feeds/cells/1mcsw796p1dt9C4njlvOu9Xuvgn4Ztmc2SZonopawBSs/4/public/full?alt=json'
# uri = URI(url)
# response = Net::HTTP.get(uri)
# fixture_hash = JSON.parse(response)

# allcells = fixture_hash["feed"]["entry"]
# $x = 0
# $temp = []

# allcells.each do |acell|

# 	if (acell["gs$cell"]["row"].to_i != 1)

# 	$x += 1

# 	  case acell["gs$cell"]["col"].to_i
# 	  when 1
# 	    $temp << acell["gs$cell"]["$t"]
# 	  when 2
# 	    $temp << acell["gs$cell"]["$t"]
# 	  when 3
# 	    $temp << acell["gs$cell"]["$t"].to_i
# 	  when 4
# 	    $temp << Team.where(city:acell["gs$cell"]["$t"]).take
# 	  when 5
# 	    $temp << Team.where(city:acell["gs$cell"]["$t"]).take
# 	  when 6
# 	    $temp << acell["gs$cell"]["$t"]
# 	  when 7
# 	    $temp << acell["gs$cell"]["$t"]
# 	  when 8
# 	    $temp << acell["gs$cell"]["$t"]
# 	  end

# 		puts "Done for cell #{$x}"

# 		if ($x % 8 == 0)
# 			Fixture.create(date:$temp[0],time:$temp[1],home_team:$temp[3],away_team:$temp[4],status:$temp[7],stage:$temp[2],scorehome:$temp[5],scoreaway:$temp[6])
# 			puts "Game created"
# 			$temp.clear
# 		end
			
# 	end
# end

################################################################################################
############################ Feed the DB with L1 players from scraping ##################################
################################################################################################

require 'open-uri'
require 'nokogiri'

alphabet = (10...36).map{ |i| i.to_s 36}

alphabet.each do |letter|
	url = "http://www.madeinfoot.com/ligue-1/l1-liste-#{letter.capitalize}.html"

	# url = "http://www.madeinfoot.com/ligue-1/l1-liste-A.html"

	html_doc = Nokogiri::HTML(open(url))

	selector = ".list-unstyled.joueurs > li"

	x=0
	$temp = []

	html_doc.search(selector).each do |element|

		x += 1

		case x
		when 1
			$temp << element.text[0..element.text.rindex(' ')-1] #First name
			$temp << element.text.split(' ')[-1] #Last name
		when 2
			$temp << Team.where(city:element.text).take #Team
		when 3
			$temp << element.text.strip #Nationality
		end

		if (x % 6 == 0)
			x = 0
			# The team must exist here
			p Player.create(first_name:$temp[1],last_name:$temp[0],nationality:$temp[3],team:$temp[2]).valid?
			puts "Player #{$temp[1]} #{$temp[0]} (#{$temp[3]}) created"
			$temp.clear
		end

	end
end

