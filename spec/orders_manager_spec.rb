require 'rspec'
require 'data_repository'
require 'orders_manager'

RSpec::Matchers.define :contain_orders do |*expected_orders|
  match do |orders|
    result = true
    orders.each_with_index { |order, index|
      expected_order = expected_orders[index]
      result = (order.date == expected_order.date && order.reason == expected_order.reason)
    }
    result
  end

  diffable
end

RSpec::Matchers.define :be_same_order do |expected_order|
  match do |order|
    order.date == expected_order.date && order.reason == expected_order.reason
  end

  diffable
end

describe OrdersManager do
  PATH = 'test_tmp'.freeze

  let(:first_order) do
    RepairOrder.new(Date.today, 'first order')
  end

  let(:second_order) do
    RepairOrder.new(Date.today + 1, 'second order')
  end

  after(:each) do
    FileUtils.rm_r(PATH) if File.exist?(PATH)
  end

  context 'when it is newly created' do
    it 'must return empty array' do
      orders_manager = described_class.new(DataRepository.new(PATH))
      expect(orders_manager.orders).to be_empty
    end
  end

  context 'when few orders was added' do
    it 'must contain added orders' do
      orders_manager = described_class.new(DataRepository.new(PATH))
      orders_manager.add_new_order(Date.today, 'first order')
      orders_manager.add_new_order(Date.today + 1, 'second order')
      expect(orders_manager.orders).to contain_orders(first_order, second_order)
    end
  end

  context 'when order was added and deleted' do
    it 'must return empty array' do
      orders_manager = described_class.new(DataRepository.new(PATH))
      orders_manager.add_new_order(Date.today, 'first order')
      orders_manager.remove_order_at_position(0)
      expect(orders_manager.orders).to be_empty
    end
  end

  context 'when second manager was created' do
    it 'must contain same orders' do
      orders_manager = described_class.new(DataRepository.new(PATH))
      orders_manager.add_new_order(Date.today, 'first order')
      new_orders_manager = described_class.new(DataRepository.new(PATH))
      expect(new_orders_manager.orders[0]).to be_same_order(first_order)
    end
  end

end