class Fixture < ApplicationRecord
  belongs_to :home_team, :class_name => 'Team'
  belongs_to :away_team, :class_name => 'Team'
  has_many :ranks,  dependent: :destroy 
  has_many :events,  dependent: :destroy
  accepts_nested_attributes_for :events, allow_destroy: true, reject_if: :all_blank
end
