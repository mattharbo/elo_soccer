class Player < ApplicationRecord
  belongs_to :team
  has_many :events
  accepts_nested_attributes_for :events, allow_destroy: true, reject_if: :all_blank
end
