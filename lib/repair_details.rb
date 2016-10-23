# This is the repair details class which contains the
# information about car and owner of the repair order
class RepairDetails
  attr_reader :reason, :car, :owner

  def initialize(reason, car, owner)
    @reason = reason
    @car = car
    @owner = owner
  end

  def to_s
    "[Reason: #{@reason}; Car: #{@car}; Owner: #{@owner}]"
  end
end
