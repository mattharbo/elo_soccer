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

		@fixtureevents = Event.where(fixture:params[:id])
	end

	def tocomplete
		# /!\ This query has to be improved taking "time" into account!
		@fixturetocomplete = Fixture.where("DATE(date) <= ?", Date.today).where(completed:nil).order(date: :asc)
	end

	def edit
		@fixture = Fixture.find(params[:id])

		#######################################
		### ADDED FOR THE EVENTS CREATION ###

		homeplayers_for_array = Player.where(team:@fixture.home_team)
		
		@homeplayers = homeplayers_for_array.map do |d|
			[d.first_name+" "+d.last_name, d.id]
		end
		@homeplayers.unshift(nil)

		awayplayers_for_array = Player.where(team:@fixture.away_team)
		@awayplayers = awayplayers_for_array.map do |d|
			[d.first_name+" "+d.last_name, d.id]
		end
		@awayplayers.unshift(nil)

		#######################################

	end

	def update
		################
		# Fixture update
		################
		@fixturetoupdate = Fixture.find(params[:id])
		@fixturetoupdate.completed = true
		@fixturetoupdate.status = "played" # /!\ Should be removed when status auto updated by CRON task
		@fixturetoupdate.update(fixture_params)
		################
		# Ranking update
		################
		homerank = Rank.where(team:@fixturetoupdate.home_team).last.level
		awayrank = Rank.where(team:@fixturetoupdate.away_team).last.level
		homescore = params[:fixture][:scorehome]
		awayscore = params[:fixture][:scoreaway]
		# ---- Home team
		newhomerank = rank_calculation(homerank,
			k_factor(homerank),
			game_result(homescore,awayscore),
			win_rate(homerank,awayrank))
		Rank.create(fixture:@fixturetoupdate,team:@fixturetoupdate.home_team,level:newhomerank)
		# ---- Away team
		newawayrank = rank_calculation(awayrank,
			k_factor(awayrank),
			game_result(awayscore,homescore),
			win_rate(awayrank,homerank))
		Rank.create(fixture:@fixturetoupdate,team:@fixturetoupdate.away_team,level:newawayrank)
		################

		eventfixture = Fixture.find(params[:id])
		eventtype = Eventtype.where(name:"Goal").take

		params[:fixture][:events_attributes].each do |key, value|

			if !value[:minute].empty?
				eventmin = value[:minute]
				eventplayer = Player.find(value[:player])
				eventteam = Fixture.find(params[:id]).home_team # tous les events pour la home team par défault dans un 1er temps

				eventcreationhash = {fixture:eventfixture,eventtype:eventtype,minute:eventmin,player:eventplayer,team:eventteam}

				unless value[:other_player].empty?
					eventotherplayer = Player.find(value[:other_player])
					eventcreationhash["other_player"]=eventotherplayer
				end

				Event.create(eventcreationhash)

			end
		end

		redirect_to to_complete_fixtures_path
	end

	####################
	### Private methods started from here !!
	####################
	private

	def fixture_params
		params.require(:fixture).permit(:date, :time, :home_team, :away_team, :scorehome, :scoreaway, :status, :stage)
	end

	def k_factor(ranking)
		case
		when ranking < 1800
			kfactor=80
		when (1800..1899) === ranking
			kfactor=70
		when (1900..1999) === ranking
			kfactor=60
		when (2000..2099) === ranking
			kfactor=50
		when (2100..2199) === ranking
			kfactor=40
		when (2200..2299) === ranking
			kfactor=30
		when ranking >= 2300
			kfactor=20
		end
		return kfactor
	end

	def win_rate(p1ranking,p2ranking)
		winrate = 1/(1+10**((p2ranking.to_f-p1ranking.to_f)/400))
		return winrate
	end

	def game_result(team_score, opponent_score)
		case 
		when team_score < opponent_score
			gameresult = 0
		when team_score == opponent_score
			gameresult = 0.5
		when team_score > opponent_score
			gameresult = 1
		end
	end

	def rank_calculation(prev_rank, k_factor, game_result, win_rate)
		new_rank = prev_rank + k_factor*(game_result - win_rate)
		return new_rank.round(0)
	end
end
