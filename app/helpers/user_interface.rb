# This class provides console style user interface
class UserInterface
  def initialize
    @orders_manager = OrdersManager.new
  end

  def show_main_menu
    loop do
      puts '=== MENU ==='
      puts '1. Add new repair order | 2. Show all repair orders | 3. Exit'
      selected_item = user_selection
      case selected_item
      when 1
        add_new_repair_order
      when 2
        show_all_repair_orders
      end
      break if selected_item == 3
    end
  end

  def add_new_repair_order
    repair_date = user_input('repair date')
    repair_reason = user_input('repair reason')
    car_info = user_input('car info')
    client_info = user_input('client info')
    @orders_manager.add_new_order(Date.strptime(repair_date, '%Y%m%d'),
                      Detail.new(reason: repair_reason, car: car_info, owner: client_info)
    )
  end

  def show_all_repair_orders
    orders = @orders_manager.orders

    if !orders.empty?
      puts '=== ORDERS ==='
      orders.each do |order|
        puts "Id: #{order.id}, Repair date: #{order.date}, " \
  "State: #{order.state}, Details: #{order.detail}"
      end
      puts '=============='
      show_orders_submenu
    else
      puts 'There is nothing to show, please add orders at first!'
    end
  end

  def show_orders_submenu
    loop do
      puts '1. Delete | 2. Edit | 3. Back to main menu'
      selected_item = user_selection
      case selected_item
      when 1
        delete_order
      when 2
        edit_order
      end
      break if selected_item == 3 || @orders_manager.orders.empty?
    end
  end

  def delete_order
    order_id = user_input('order id').to_i
    @orders_manager.remove_order_by_id(order_id)
  end

  def edit_order
    order_id = user_input('order id').to_i
    loop do
      puts '1. Change repair date | 2. Change order state | 3. Back'
      selected_item = user_selection
      case selected_item
      when 1
        change_repair_date(order_id)
      when 2
        change_order_state(order_id)
      end
      break if selected_item == 3
    end
  end

  def change_repair_date(order_id)
    repair_date = user_input('repair date')
    @orders_manager.update_date(order_id, Date.strptime(repair_date, '%Y%m%d'))
  end

  def change_order_state(order_id)
    loop do
      puts '1. Ongoing | 2. Completed'
      selected_item = user_selection
      case selected_item
      when 1
        @orders_manager.mark_as_ongoing(order_id)
        break
      when 2
        @orders_manager.mark_as_completed(order_id)
        break
      end
    end
  end

  def user_input(input_param)
    puts "Enter #{input_param}:"
    gets.chomp.strip
  end

  def user_selection
    gets.chomp.strip.to_i
  end
end
