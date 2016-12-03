# This is the repair order class which holds the
# client, car, order state and repair report
class Order < ApplicationRecord
  has_one :detail, inverse_of: :order, dependent: :destroy
  has_one :report, dependent: :destroy
  after_initialize :set_pending_state
  validates :date, presence: true
  validates :state, inclusion: %w(pending ongoing completed)
  accepts_nested_attributes_for :detail, allow_destroy: true

  def date=(date)
    error_message = 'only pending order date can be changed'
    raise error_message if state != 'pending' && !new_record?
    super(date)
  end

  def report=(report)
    error_message = 'report can only be assigned to ongoing order'
    raise error_message if state != 'ongoing'
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
    self.state = 'pending' if new_record?
  end
end
