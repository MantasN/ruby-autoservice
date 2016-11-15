require 'rails_helper'

RSpec::Matchers.define :eq_details do |expected_details|
  match do |details|
    details.reason == expected_details.reason &&
      details.car == expected_details.car &&
      details.owner == expected_details.owner
  end

  diffable
end

describe Order, type: :model do
  fixtures :all

  context 'newly created' do
    let(:new_order) do
      described_class.new(date: Date.today)
    end

    it 'must have pending state' do
      expect(new_order.state).to eq('pending')
    end

    it 'must return today as repair date' do
      expect(new_order.date).to eq(Date.today)
    end

    it 'must allow to change the repair date' do
      new_order.date = tomorrow = Date.today + 1
      expect(new_order.date).to eq tomorrow
    end

    it 'must not have repair report' do
      expect(new_order.report).to be_nil
    end

    it 'must not let to assign repair report' do
      expect { new_order.report = instance_double('Report') }
        .to raise_error('report can only be assigned to ongoing order')
    end

    context 'when saved' do
      it 'must allow to change the repair date' do
        new_order.save
        new_order.date = tomorrow = Date.today + 1
        expect(new_order.date).to eq tomorrow
      end
    end
  end

  context 'existing pending order' do
    let(:order) do
      orders(:pending_order)
    end

    it 'must do not have details' do
      expect(order.detail).to be_nil
    end

    context 'marked as ongoing' do
      before do
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

    context 'marked as completed' do
      before do
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
        expect { order.report = instance_double('Report') }
          .to raise_error('report can only be assigned to ongoing order')
      end
    end
  end

  context 'existing ongoing order' do
    let(:order) do
      orders(:ongoing_order)
    end

    it 'must return ongoing state' do
      expect(order.state).to eq('ongoing')
    end

    it 'must return specified details' do
      expect(order.detail)
        .to eq_details(instance_double('Detail', reason: 'need to change tires',
                                                 car: 'VW GOLF 6',
                                                 owner: 'Mantas Neviera'))
    end

    it 'must return 2016-11-11 as repair date' do
      expect(order.date).to eq(Date.parse('2016-11-11'))
    end
  end
end
