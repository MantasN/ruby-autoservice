# This is the repair job class which contains the
# price and title of the completed job
class Job < ApplicationRecord
  belongs_to :report
  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
