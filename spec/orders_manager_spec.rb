require 'rspec'
require 'data_repository'
require 'orders_manager'
require 'repair_order'
require 'repair_details'

RSpec::Matchers.define :contain_orders do |*expected_orders|
  match do |orders|
    result = true
    orders.each_with_index do |order, index|
      expected_order = expected_orders[index]
      result = (order.date == expected_order.date &&
          order.state == expected_order.state &&
          order.repair_details.reason == expected_order.repair_details.reason &&
          order.repair_details.car == expected_order.repair_details.car &&
          order.repair_details.owner == expected_order.repair_details.owner)
    end
    result
  end

  diffable
end

RSpec::Matchers.define :eq_order do |expected_order|
  match do |order|
    order.date == expected_order.date &&
      order.state == expected_order.state &&
      order.repair_details.reason == expected_order.repair_details.reason &&
      order.repair_details.car == expected_order.repair_details.car &&
      order.repair_details.owner == expected_order.repair_details.owner
  end

  diffable
end

describe OrdersManager do
  OM_TEST_PATH = 'om_test_tmp'.freeze

  let(:first_order) do
    RepairOrder.new(
      Date.today,
      RepairDetails.new('first order', 'VW GOLF 6', 'Mantas Neviera')
    )
  end

  let(:second_order) do
    RepairOrder.new(
      Date.today + 1,
      RepairDetails.new('second order', 'BMW F10', 'Greta')
    )
  end

  let(:orders_manager) do
    described_class.new(DataRepository.new(OM_TEST_PATH))
  end

  after(:each) do
    FileUtils.rm_r(OM_TEST_PATH) if File.exist?(OM_TEST_PATH)
  end

  context 'when it is newly created' do
    it 'must return empty array' do
      expect(orders_manager.orders).to be_empty
    end
  end

  context 'when few orders was added' do
    it 'must contain added orders' do
      orders_manager.add_new_order(first_order)
      orders_manager.add_new_order(second_order)
      expect(orders_manager.orders).to contain_orders(first_order, second_order)
    end
  end

  context 'when order was added and deleted' do
    it 'must return empty array' do
      orders_manager.add_new_order(first_order)
      orders_manager.remove_order_at_position(0)
      expect(orders_manager.orders).to be_empty
    end
  end

  context 'when second manager was created' do
    it 'must contain same order' do
      orders_manager.add_new_order(first_order)
      new_orders_manager = described_class.new(DataRepository.new(OM_TEST_PATH))
      expect(new_orders_manager.orders[0]).to eq_order(first_order)
    end
  end

  context 'when trying to updated date' do
    it 'must return updated date if state was pending' do
      orders_manager.add_new_order(first_order)
      orders_manager.update_date(0, Date.today + 1)
      expect(orders_manager.orders[0].date).to eq(Date.today + 1)
    end

    it 'must return old date if state was not pending' do
      orders_manager.add_new_order(first_order)
      orders_manager.mark_as_ongoing(0)
      orders_manager.update_date(0, Date.today + 1)
      expect(orders_manager.orders[0].date).to eq(Date.today)
    end
  end

  context 'when trying to change state' do
    it 'must return pending when created' do
      orders_manager.add_new_order(first_order)
      expect(orders_manager.orders[0].state).to eq(:pending)
    end

    it 'must return ongoing when changed to it' do
      orders_manager.add_new_order(first_order)
      orders_manager.mark_as_ongoing(0)
      expect(orders_manager.orders[0].state).to eq(:ongoing)
    end

    it 'must return completed when changed to it' do
      orders_manager.add_new_order(first_order)
      orders_manager.mark_as_completed(0)
      expect(orders_manager.orders[0].state).to eq(:completed)
    end
  end
end
