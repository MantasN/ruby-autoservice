require 'rails_helper'

RSpec::Matchers.define :eq_details do |expected_details|
  match do |details|
    details.reason == expected_details.reason &&
      details.car == expected_details.car &&
      details.owner == expected_details.owner
  end

  diffable
end

describe Order, :type => :model do
  fixtures :all

  let(:order) do
    orders(:mantas_order)
  end

  context 'newly created' do
    it 'must have pending state' do
      expect(order.state).to eq('pending')
    end

    it 'must return today as repair date' do
      expect(order.date).to eq(Date.parse('2016-11-11'))
    end

    it 'must allow to change the repair date' do
      order.date = today = Date.today
      expect(order.date).to eq today
    end

    it 'must not have repair report' do
      expect(order.report).to be_nil
    end

    it 'must not let to assign repair report' do
      expect { order.report = double('report') }
        .to raise_error('report can only be assigned to ongoing order')
    end

    it 'must return specified details' do
      expect(order.detail)
        .to eq_details(double('detail', :reason => 'need to change tires',
                                         :car => 'VW GOLF 6', :owner => 'Mantas Neviera'))
    end
  end

  context 'marked as ongoing' do
    before(:each) do
      order.ongoing
    end

    it 'must return ongoing state' do
      expect(order.state).to eq('ongoing')
    end

    it 'must complain when changing the repair date' do
      expect { order.date = Date.today }
        .to raise_error('only pending order date can be changed')
    end

    it 'must let to assign repair report' do
      order.report = repair_report = Report.new
      expect(order.report).to eq(repair_report)
    end
  end
#
  context 'marked as completed' do
    before(:each) do
      order.completed
    end

    it 'must return completed state' do
      expect(order.state).to eq('completed')
    end

    it 'must complain when changing the repair date' do
      expect { order.date = Date.today }
        .to raise_error('only pending order date can be changed')
    end

    it 'must not let to assign repair report' do
      expect { order.report = double('report') }
        .to raise_error('report can only be assigned to ongoing order')
    end
  end
end
