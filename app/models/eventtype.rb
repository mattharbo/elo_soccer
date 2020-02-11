class Eventtype < ApplicationRecord
	has_many :events,  dependent: :destroy
	accepts_nested_attributes_for :events, allow_destroy: true, reject_if: :all_blank
end
