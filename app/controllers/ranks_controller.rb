class RanksController < ApplicationController
	def index
		@ranks = []

		ranking = []
		teams = Team.all
		teams.each do |targetteam|
			tempteam = []
			theteam = Rank.where(team:targetteam).last
			tempteam << theteam.team.name
			tempteam << theteam.level
			ranking << tempteam
		end
		@theranking = ranking.sort { |a,b| b[1] <=> a[1] }
	end

	def initializeranking
		@teams = Team.all.order(level: :desc)
		defaultlevel = 2000
		@teams.each do |team|
			Rank.create(team:team,level:defaultlevel)
		end
		redirect_to ranks_path
	end
end