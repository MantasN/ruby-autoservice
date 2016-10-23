require_relative 'data_repository'
require_relative 'repair_order'

# This class provides the possibility to interact with orders
# store, add, delete and retrieve
class OrdersManager
  attr_reader :orders

  def initialize(data_repository)
    @data_repository = data_repository
    @orders = @data_repository.load_data || []
  end

  def add_new_order(date, reason)
    @orders.push(RepairOrder.new(date, reason))
    save
  end

  def remove_order_at_position(position)
    @orders.delete_at(position)
    save
  end

  def save
    @data_repository.save_data(@orders)
  end
end