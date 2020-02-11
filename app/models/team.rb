class Team < ApplicationRecord
	has_many :fixtures
	has_many :ranks
	has_many :players
	has_many :events
	accepts_nested_attributes_for :events, allow_destroy: true, reject_if: :all_blank
end
