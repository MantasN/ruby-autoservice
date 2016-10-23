require_relative 'data_repository'

# This class provides the possibility to interact with orders
# store, add, delete and retrieve
class OrdersManager
  attr_reader :orders

  def initialize(data_repository)
    @data_repository = data_repository
    @orders = @data_repository.load_data || []
  end

  def add_new_order(order)
    @orders.push(order)
    save
  end

  def remove_order_at_position(position)
    @orders.delete_at(position)
    save
  end

  def update_date(index, new_date)
    selected_order = @orders[index]
    selected_order.date = new_date unless selected_order.state != :pending
    save
  end

  def mark_as_ongoing(index)
    @orders[index].ongoing
    save
  end

  def mark_as_completed(index)
    @orders[index].completed
    save
  end

  def save
    @data_repository.save_data(@orders)
  end
end
