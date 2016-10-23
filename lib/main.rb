require_relative 'user_interface'
require_relative 'orders_manager'
require_relative 'data_repository'

DB_PATH = '../storage/data'.freeze

orders_manager = OrdersManager.new(DataRepository.new(DB_PATH))
user_interface = UserInterface.new(orders_manager)
user_interface.show_main_menu
