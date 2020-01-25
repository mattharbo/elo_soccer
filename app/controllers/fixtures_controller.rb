class FixturesController < ApplicationController
	def index
		@fixtures = Fixture.all.order(date: :desc)
	end

	def new
		@fixture = Fixture.new
		i=1
		@stages =[]

		while i<=38
			@stages << i
			i=i+1
		end
		
		teams_for_array = Team.all.order(city: :asc)
		@teams = teams_for_array.map do |d|
			[d.city, d.id]
		end
	end

	def create
		date = params[:fixture][:date]
		time = params[:fixture][:time]

		case 
		when Date.parse(date) < Date.today
			status = "played"
		when Date.parse(date) > Date.today
			status = "scheduled"
		else #today's date
			if (time.to_time - Time.now).abs < 11400
				status = "played"
			else
				status = "scheduled"
			end
		end
		
		home_t = Team.find(params[:home_team].to_i)
		away_t = Team.find(params[:away_team].to_i)
		stage = params[:stage]
		Fixture.create(date:date,time:time,home_team:home_t,away_team:away_t,status:status,stage:stage)

		redirect_to fixtures_path
	end

	def show
		@fixture = Fixture.find(params[:id])
	end

	def tocomplete
		# /!\ This query has to be improved taking "time" into account!
		@fixturetocomplete = Fixture.where("DATE(date) <= ?", Date.today).where(completed:nil).order(date: :asc)
	end

	def edit
		@fixture = Fixture.find(params[:id])
	end

	def update
		@fixturetoupdate = Fixture.find(params[:id])
		@fixturetoupdate.completed = true
		@fixturetoupdate.status = "played" # /!\ Should be removed when status auto updated by CRON task
		@fixturetoupdate.update(fixture_params)
		redirect_to to_complete_fixtures_path
	end

	####################
	### Private methods started from here !!
	####################
	private

	def fixture_params
		params.require(:fixture).permit(:date, :time, :home_team, :away_team, :scorehome, :scoreaway, :status, :stage)
	end
end
