class Rank < ApplicationRecord
  belongs_to :fixture, optional: true
  belongs_to :team
end
