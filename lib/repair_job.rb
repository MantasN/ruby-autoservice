# This is the repair job class which contains the
# price and title of the completed job
class RepairJob
  attr_reader :title, :price

  def initialize(title, price)
    @title = title
    @price = price
  end
end
