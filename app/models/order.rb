# This is the repair order class which holds the
# client, car, order state and repair report
class Order < ApplicationRecord
  has_one :detail, dependent: :destroy
  has_one :report, dependent: :destroy
  after_initialize :set_pending_state
  validates :date, presence: true
  validates :state, inclusion: %w(pending ongoing completed)

  def date=(date)
    raise 'only pending order date can be changed' if (self.state != nil && self.state != 'pending')
    super(date)
  end

  def report=(report)
    raise 'report can only be assigned to ongoing order' if self.state != 'ongoing'
    super(report)
  end

  def ongoing
    self.state = 'ongoing'
  end

  def completed
    self.state = 'completed'
  end

  protected
  def set_pending_state
    self.state = 'pending'
  end
end
