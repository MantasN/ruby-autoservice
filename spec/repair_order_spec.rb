require 'rspec'
require 'repair_order'
require 'repair_report'
require 'repair_details'

RSpec::Matchers.define :eq_details do |expected_details|
  match do |details|
    details.reason == expected_details.reason &&
      details.car == expected_details.car &&
      details.owner == expected_details.owner
  end

  diffable
end

describe RepairOrder do
  let(:repair_order) do
    described_class.new(
      Date.today,
      RepairDetails.new('need to change brake pads',
                        'VW GOLF 6', 'Mantas Neviera')
    )
  end

  context 'newly created' do
    it 'must have pending state' do
      expect(repair_order.state).to eq(:pending)
    end

    it 'must return today as repair date' do
      expect(repair_order.date).to eq(Date.today)
    end

    it 'must allow to change the repair date' do
      repair_order.date = tomorrow = Date.today + 1
      expect(repair_order.date).to eq tomorrow
    end

    it 'must not have repair report' do
      expect(repair_order.report).to be_nil
    end

    it 'must not let to assign repair report' do
      expect { repair_order.report = RepairReport.new }
        .to raise_error('report can only be assigned to ongoing order')
    end

    it 'must return specified details' do
      expect(repair_order.repair_details)
        .to eq_details(RepairDetails.new('need to change brake pads',
                                         'VW GOLF 6', 'Mantas Neviera'))
    end
  end

  context 'marked as ongoing' do
    before(:each) do
      repair_order.ongoing
    end

    it 'must return ongoing state' do
      expect(repair_order.state).to eq(:ongoing)
    end

    it 'must complain when changing the repair date' do
      expect { repair_order.date = Date.today + 1 }
        .to raise_error('only pending order date can be changed')
    end

    it 'must let to assign repair report' do
      repair_order.report = repair_report = RepairReport.new
      expect(repair_order.report).to eq(repair_report)
    end
  end

  context 'marked as completed' do
    before(:each) do
      repair_order.completed
    end

    it 'must return completed state' do
      expect(repair_order.state).to eq(:completed)
    end

    it 'must complain when changing the repair date' do
      expect { repair_order.date = Date.today + 1 }
        .to raise_error('only pending order date can be changed')
    end

    it 'must not let to assign repair report' do
      expect { repair_order.report = RepairReport.new }
        .to raise_error('report can only be assigned to ongoing order')
    end
  end
end
