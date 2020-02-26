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

	def show
		@team = Team.find(params[:id])

		@teamplayers = Player.where(team:params[:id])

		@gameserie = Fixture.where("status = ? and home_team_id = ?", "played", @team).or(Fixture.where("status = ? and away_team_id = ?", "played", @team)).reverse
	end

	####################
	### Private methods started from here !!
	####################

	private

	def team_params
		params.require(:team).permit(:name, :acronym, :city, :light_color)
	end
end
