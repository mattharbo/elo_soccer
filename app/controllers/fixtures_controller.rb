class FixturesController < ApplicationController
	def index
		@fixtures = Fixture.all
	end
end
