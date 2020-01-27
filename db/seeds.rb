# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'net/http'
require 'json'

url = 'https://spreadsheets.google.com/feeds/cells/1mcsw796p1dt9C4njlvOu9Xuvgn4Ztmc2SZonopawBSs/4/public/full?alt=json'
uri = URI(url)
response = Net::HTTP.get(uri)
fixture_hash = JSON.parse(response)

# 240 matchs au total
# 50 premier matchs (50) => 1..400
# 50 matchs suivant (100) => 401..800
# 50 matchs suivant (150) => 801..1200
# 50 matchs suivant (200) => 1201..1600
# 50 matchs suivant (250) => 1601..2000

x = 1
y = 1

while (x > 0) && (x <= 2000)
	if (fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"] != "date") && (fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"] != "time") && (fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"] != "stage") && (fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"] != "home_team") && (fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"] != "away_team") && (fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"] != "scorehome") && (fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"] != "scoreaway") && (fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"] != "status")

	  case fixture_hash["feed"]["entry"][x]["gs$cell"]["col"]
	  when "1"
	    date=fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"]
	  when "2"
	    time=fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"]
	  when "3"
	    stage=fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"].to_i
	  when "4"
	    home_team=Team.where(city:fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"]).take
	  when "5"
	    away_team=Team.where(city:fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"]).take
	  when "6"
	    scorehome=fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"]
	  when "7"
	    scoreaway=fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"]
	  when "8"
	    status=fixture_hash["feed"]["entry"][x]["gs$cell"]["$t"]
	  end

	  if (y == 8)
	  	Fixture.create(date:date,time:time,home_team:home_team,away_team:away_team,status:status,stage:stage,scorehome:scorehome,scoreaway:scoreaway)
	  	puts "New game created!"
	  	y = 1
	  else
	  	y += 1
	  end

	end
	puts "Done for #{x}"
	x += 1
end

