class RanksController < ApplicationController
	def index
		@ranks = Rank.all

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
end

# Rank.create(team:Team.find(1),level:2000)
# Rank.create(team:Team.find(2),level:2000)
# Rank.create(team:Team.find(3),level:2000)
# Rank.create(team:Team.find(4),level:2000)
# Rank.create(team:Team.find(5),level:2000)
# Rank.create(team:Team.find(6),level:2000)
# Rank.create(team:Team.find(7),level:2000)
# Rank.create(team:Team.find(8),level:2000)
# Rank.create(team:Team.find(9),level:2000)
# Rank.create(team:Team.find(10),level:2000)
# Rank.create(team:Team.find(11),level:2000)
# Rank.create(team:Team.find(12),level:2000)
# Rank.create(team:Team.find(13),level:2000)
# Rank.create(team:Team.find(14),level:2000)
# Rank.create(team:Team.find(15),level:2000)
# Rank.create(team:Team.find(16),level:2000)
# Rank.create(team:Team.find(17),level:2000)
# Rank.create(team:Team.find(18),level:2000)
# Rank.create(team:Team.find(19),level:2000)
# Rank.create(team:Team.find(20),level:2000)