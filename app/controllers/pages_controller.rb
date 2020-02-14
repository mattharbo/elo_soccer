class PagesController < ApplicationController
	def home
		targetstage = Fixture.where(completed:true).last.stage
		Fixture.where(stage:targetstage,completed:true).count == 10 ? stage=targetstage+1 : stage=targetstage
		# showcasedgames = Fixture.where(stage:stage).order(date: :asc, time: :asc)
		showcasedgames = Fixture.where(stage: 1..stage).order(stage: :desc, date: :desc).group_by(&:stage)

		@gamehistory=Array.new

		showcasedgames.each do |journey|

			counter=0

			day=Hash.new

			day[:stage]=journey[0] #Stage number
			day[:games]=Hash.new

			journey[1].each do |game| #Tables with all games of the stage

				counter += 1

				one_game=Hash.new

				if game.completed? #When a game is complete
					one_game[:status]="completed"
					one_game[:scorehome]=game.scorehome
					one_game[:scoreaway]=game.scoreaway
					one_game[:hometeamevents]=Event.where(fixture:game.id,team:game.home_team)
					one_game[:awayteamevents]=Event.where(fixture:game.id,team:game.away_team)
				else
					one_game[:status]="incompleted"
					one_game[:date]=definedate(game.date)
					one_game[:time]=game.time.to_s(:time)
					one_game[:homewinrate]=win_rate(Rank.where(team:game.home_team).last.level,Rank.where(team:game.away_team).last.level)
					one_game[:awaywinrate]=win_rate(Rank.where(team:game.away_team).last.level,Rank.where(team:game.home_team).last.level)
				end

				one_game[:gameid]=game.id
				one_game[:hometeam]=game.home_team.city
				one_game[:awayteam]=game.away_team.city

				day[:games][counter.to_s] = one_game

			end			

			@gamehistory << day
	
		end

		ranking = []
		teams = Team.all
		teams.each do |targetteam|
			tempteam = []
			theteam = Rank.where(team:targetteam).last
			tempteam << theteam.team.acronym
			tempteam << theteam.level
			ranking << tempteam
		end
		@theranking = ranking.sort { |a,b| b[1] <=> a[1] }
	end

	####################
	### Private methods started from here !!
	####################
	private

	def win_rate(p1ranking,p2ranking)
		winrate = 1/(1+10**((p2ranking.to_f-p1ranking.to_f)/400))
		return winrate
	end

	def definedate(inputdate)
		thedate = inputdate.strftime("%Y-%m-%d")
		tdy = Time.now.strftime("%Y-%m-%d").to_str
		fortmrw = Time.now+(24*60*60)
		tmrw = fortmrw.strftime("%Y-%m-%d").to_str

		case thedate
		when tdy
			return "Today"
		when tmrw
			return "Tomorrow"
		else
			return inputdate.strftime("%d/%m") # ID 3	
		end
	end

	def definetime(inputtime)

		# return Time.at(Time.now-inputtime).strftime("%H:%M:%S")
		# return Time.now-inputtime
		# return Time.at(105*60*60)

		# if () < ()
		# 	return "Live"
		# else
		# 	return inputtime.to_s(:time)
		# end

	end
end