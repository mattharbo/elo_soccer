class RanksController < ApplicationController
	def index
		@ranks = Rank.all
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
