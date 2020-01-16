class TeamsController < ApplicationController
	def index
		@teams = Team.all		
	end

	def new
		@team = Team.new
	end

	def create
		Team.create(team_params)
		redirect_to teams_path
	end

	private

	def team_params
		params.require(:team).permit(:name, :acronym, :city, :light_color)
	end
end
