class Event < ApplicationRecord
  belongs_to :fixture
  belongs_to :eventtype
  belongs_to :player, :class_name => 'Player'
  belongs_to :team
  belongs_to :other_player, :class_name => 'Player', optional: true
end
