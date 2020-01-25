class Team < ApplicationRecord
	has_many :fixtures
	has_many :rankings
end
