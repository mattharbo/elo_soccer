class Team < ApplicationRecord
	has_many :fixtures
	has_many :ranks
	has_many :players
end
