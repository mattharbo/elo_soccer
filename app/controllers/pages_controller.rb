class PagesController < ApplicationController
	def home
		targetstage = Fixture.where(completed:true).last.stage
		Fixture.where(stage:targetstage,completed:true).count == 10 ? stage=targetstage+1 : stage=targetstage
		showcasedgames = Fixture.where(stage:stage).order(date: :asc, time: :asc)

		@games = []

		showcasedgames.each do |game|

			line = []

			if game.completed?
				line << "complete" # ID 0
				line << game.scorehome # ID 1
				line << game.scoreaway # ID 2
			else
				line << "incomplete" # ID 0
				line << win_rate(Rank.where(team:game.home_team).last.level,Rank.where(team:game.away_team).last.level) # ID 1
				line << win_rate(Rank.where(team:game.away_team).last.level,Rank.where(team:game.home_team).last.level) # ID 2

				thedate = game.date.strftime("%Y-%m-%d")
				tdy = Time.now.strftime("%Y-%m-%d").to_str
				fortmrw = Time.now+(24*60*60)
				tmrw = fortmrw.strftime("%Y-%m-%d").to_str

				case thedate
				when tdy
					line << "Today"
				when tmrw
					line << "Tomorrow"
				else
					line << game.date.strftime("%d/%m") # ID 3	
				end

				line << game.time.to_s(:time) # ID 4
			end

			line << game.home_team.city # ID 3 / 5
			line << game.away_team.city # ID 4 / 6
			line << game.id # ID 5 / 7
			@games << line
	
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
end