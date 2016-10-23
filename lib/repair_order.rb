# This is the repair order class which holds the
# client, car, order state and repair report
class RepairOrder
  attr_reader :state, :date, :report, :repair_details

  def initialize(date, repair_details)
    @state = :pending
    @date = date
    @repair_details = repair_details
  end

  def date=(date)
    raise 'only pending order date can be changed' if @state != :pending
    @date = date
  end

  def report=(report)
    raise 'report can only be assigned to ongoing order' if @state != :ongoing
    @report = report
  end

  def ongoing
    @state = :ongoing
  end

  def completed
    @state = :completed
  end
end
