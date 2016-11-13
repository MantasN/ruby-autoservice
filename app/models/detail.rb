# This is the repair details class which contains the
# information about car and owner of the repair order
class Detail < ApplicationRecord
  belongs_to :order
  validates :reason, :car, :owner, presence: true

  def to_s
    "[Reason: #{self.reason}; Car: #{self.car}; Owner: #{self.owner}]"
  end
end
