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

require 'net/http'
require 'json'

url = 'https://spreadsheets.google.com/feeds/cells/1mcsw796p1dt9C4njlvOu9Xuvgn4Ztmc2SZonopawBSs/4/public/full?alt=json'
uri = URI(url)
response = Net::HTTP.get(uri)
fixture_hash = JSON.parse(response)

allcells = fixture_hash["feed"]["entry"]
$x = 0
$temp = []

allcells.each do |acell|

	if (acell["gs$cell"]["row"].to_i != 1)

	$x += 1

	  case acell["gs$cell"]["col"].to_i
	  when 1
	    $temp << acell["gs$cell"]["$t"]
	  when 2
	    $temp << acell["gs$cell"]["$t"]
	  when 3
	    $temp << acell["gs$cell"]["$t"].to_i
	  when 4
	    $temp << Team.where(city:acell["gs$cell"]["$t"]).take
	  when 5
	    $temp << Team.where(city:acell["gs$cell"]["$t"]).take
	  when 6
	    $temp << acell["gs$cell"]["$t"]
	  when 7
	    $temp << acell["gs$cell"]["$t"]
	  when 8
	    $temp << acell["gs$cell"]["$t"]
	  end

		puts "Done for cell #{$x}"

		if ($x % 8 == 0)
			Fixture.create(date:$temp[0],time:$temp[1],home_team:$temp[3],away_team:$temp[4],status:$temp[7],stage:$temp[2],scorehome:$temp[5],scoreaway:$temp[6])
			puts "Game created"
			$temp.clear
		end
			
	end
end


# cell = 0
# rawcomplete = 0

# while (cell <= fixture_hash["feed"]["entry"].count)
# 	if (fixture_hash["feed"]["entry"][cell]["gs$cell"]["row"].to_i != 1)

# 	  case fixture_hash["feed"]["entry"][cell]["gs$cell"]["col"]
# 	  when "1"
# 	    date=fixture_hash["feed"]["entry"][cell]["gs$cell"]["$t"]
# 	  when "2"
# 	    time=fixture_hash["feed"]["entry"][cell]["gs$cell"]["$t"]
# 	  when "3"
# 	    stage=fixture_hash["feed"]["entry"][cell]["gs$cell"]["$t"].to_i
# 	  when "4"
# 	    home_team=Team.where(city:fixture_hash["feed"]["entry"][cell]["gs$cell"]["$t"]).take
# 	  when "5"
# 	    away_team=Team.where(city:fixture_hash["feed"]["entry"][cell]["gs$cell"]["$t"]).take
# 	  when "6"
# 	    scorehome=fixture_hash["feed"]["entry"][cell]["gs$cell"]["$t"]
# 	  when "7"
# 	    scoreaway=fixture_hash["feed"]["entry"][cell]["gs$cell"]["$t"]
# 	  when "8"
# 	    status=fixture_hash["feed"]["entry"][cell]["gs$cell"]["$t"]
# 	  end

# 	end

# 	  if rawcomplete == 8
# 	  	Fixture.create(date:date,time:time,home_team:home_team,away_team:away_team,status:status,stage:stage,scorehome:scorehome,scoreaway:scoreaway)
# 	  	puts "New game created!"
# 	  	rawcomplete = 1
# 	  else
# 	  	rawcomplete += 1
# 	  end

# 	puts "Done for #{cell}"
# 	cell += 1
# end

################################################################################################
################################################################################################
################################################################################################