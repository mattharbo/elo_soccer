class FixturesController < ApplicationController
	def index
		@fixtures = Fixture.all
		# raise
	end

	def new
		@fixture = Fixture.new
		
		teams_for_array = Team.all
		@teams = teams_for_array.map do |d|
			[d.name, d.id]
		end
	end

	def create
		date = params[:fixture][:date]
		time = params[:fixture][:time]
		home_t = Team.find(params[:home_team].to_i)
		away_t = Team.find(params[:away_team].to_i)
		Fixture.create(date:date,time:time,home_team:home_t,away_team:away_t)

		redirect_to fixtures_path
	end

	def show
		@fixture = Fixture.find(params[:id])
	end

	private

	def fixture_params
		params.require(:fixture).permit(:date, :time, :home_team, :away_team)
	end
end
