# This class provides the possibility to interact with orders
# store, add, delete and retrieve
class OrdersManager
  def orders
    Order.all
  end

  def add_new_order(date, detail)
    order = Order.new(date: date, detail: detail)
    order.save
  end

  def remove_order_by_id(id)
    order = Order.find_by(id: id)
    order.destroy
  end

  def update_date(id, new_date)
    Order.update(id, date: new_date)
  end

  def mark_as_ongoing(id)
    order = Order.find_by(id: id)
    order.ongoing
    order.save
  end

  def mark_as_completed(id)
    order = Order.find_by(id: id)
    order.completed
    order.save
  end
end
