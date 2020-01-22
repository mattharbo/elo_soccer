class FixturesController < ApplicationController
	def index
		@fixtures = Fixture.all.order(date: :asc)
	end

	def new
		@fixture = Fixture.new
		
		teams_for_array = Team.all.order(city: :asc)
		@teams = teams_for_array.map do |d|
			[d.city, d.id]
		end
	end

	def create
		date = params[:fixture][:date]

		if Date.parse(date) < Date.today 
			status = "played"
		else
			status = "scheduled"
		end

		time = params[:fixture][:time]
		home_t = Team.find(params[:home_team].to_i)
		away_t = Team.find(params[:away_team].to_i)
		Fixture.create(date:date,time:time,home_team:home_t,away_team:away_t,status:status)

		redirect_to fixtures_path
	end

	def show
		@fixture = Fixture.find(params[:id])
	end

	def tocomplete
		@fixturetocomplete = Fixture.where("DATE(date) <= ?", Date.today).where(completed:nil).order(date: :asc)
	end

	def edit
		@fixture = Fixture.find(params[:id])
	end

	def update
		@fixturetoupdate = Fixture.find(params[:id])
		@fixturetoupdate.completed = true
		@fixturetoupdate.update(fixture_params)
		redirect_to fixtures_path
	end

	####################
	### Private methods started from here !!
	####################
	private

	def fixture_params
		params.require(:fixture).permit(:date, :time, :home_team, :away_team, :scorehome, :scoreaway, :status)
	end
end
