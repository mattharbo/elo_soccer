class PagesController < ApplicationController
	def home
		targetstage = Fixture.where(completed:true).last.stage
		Fixture.where(stage:targetstage,completed:true).count == 10 ? stage=targetstage+1 : stage=targetstage
		showcasedgames = Fixture.where(stage:stage).order(date: :asc)

		@games = []

		showcasedgames.each do |game|

			line = []

			if game.completed?
				line << "complete"
				line << game.scorehome
				line << game.scoreaway
			else
				line << "incomplete"
				line << win_rate(Rank.where(team:game.home_team).last.level,Rank.where(team:game.away_team).last.level)
				line << win_rate(Rank.where(team:game.away_team).last.level,Rank.where(team:game.home_team).last.level)
			end

			line << game.home_team.acronym
			line << game.away_team.acronym
			@games << line
	
		end
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