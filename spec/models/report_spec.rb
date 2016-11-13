require 'rails_helper'

RSpec::Matchers.define :eq_array_sum do |sum|
  match do |array|
    array.reduce(0, &:+) == sum
  end
end

describe Report, :type => :model do
  let(:report) do
    described_class.new
  end

  context 'just after creation' do
    it 'completed jobs count must be 0' do
      expect(report.completed_jobs_count).to eq(0)
    end

    it 'used parts count must be 0' do
      expect(report.used_parts_count).to eq(0)
    end

    it 'must not yield when completed jobs list is empty' do
      expect { |b| report.foreach_completed_job(&b) }
        .not_to yield_control
    end

    it 'must not yield when used parts list is empty' do
      expect { |b| report.foreach_used_part(&b) }
        .not_to yield_control
    end

    it 'the total price must be 0' do
      expect(report.total_price).to eq(0)
    end

    it 'bill must contain 0 items' do
      expect(report.bill.length).to eq(0)
    end

    it 'car mileage must be nil' do
      expect(report.car_mileage).to be_nil
    end

    it 'comment must be nil' do
      expect(report.comment).to be_nil
    end
  end

  context 'job and used part were added' do
    let(:brake_pads_job) do
      Job.new(title: 'Brake pads change', price: 50)
    end

    let(:brake_pad_part) do
      Part.new(title: 'Brake pads', quantity: 2, prime_price: 10, client_price: 20)
    end

    before(:each) do
      report.add_completed_job(brake_pads_job)
      report.add_used_part(brake_pad_part)
    end

    it 'must return 1 for the completed jobs count' do
      expect(report.completed_jobs_count).to eq(1)
    end

    it 'must return 2 for the used parts count' do
      expect(report.used_parts_count).to eq(2)
    end

    it 'must return 60 for the total price' do
      expect(report.total_price).to eq(90)
    end

    it 'must yield with added job' do
      expect { |b| report.foreach_completed_job(&b) }
        .to yield_with_args(brake_pads_job)
    end

    it 'must yield with added part' do
      expect { |b| report.foreach_used_part(&b) }
        .to yield_with_args(brake_pad_part)
    end
  end

  context 'job and used part were added and deleted' do
    let(:oil_job) do
      Job.new(title: 'Oil change', price: 15)
    end

    let(:oil_part) do
      Part.new(title: 'Oil', quantity: 1, prime_price: 20, client_price: 25)
    end

    before(:each) do
      report.add_completed_job(oil_job)
      report.add_used_part(oil_part)
      report.remove_job(oil_job)
      report.remove_part(oil_part)
    end

    it 'must return 0 for the completed jobs count' do
      expect(report.completed_jobs_count).to eq(0)
    end

    it 'must return 0 for the used parts count' do
      expect(report.used_parts_count).to eq(0)
    end

    it 'must return 0 for the total price' do
      expect(report.total_price).to eq(0)
    end
  end

  context 'generating bill' do
    let(:job) do
      Job.new(title: 'Timing belts change', price: 110)
    end

    let(:timing_belt) do
      Part.new(title: 'Timing belt', quantity: 1, prime_price: 30, client_price: 40)
    end

    let(:water_pump) do
      Part.new(title: 'Water pump', quantity: 1, prime_price: 50, client_price: 70)
    end

    let(:bearing) do
      Part.new(title: 'Bearing', quantity: 2, prime_price: 25, client_price: 40)
    end

    before(:each) do
      report.add_completed_job(job)
      report.add_used_part(timing_belt)
      report.add_used_part(water_pump)
      report.add_used_part(bearing)
    end

    it 'must contain 4 items' do
      expect(report.bill.length).to eq(4)
    end

    it 'must contain exact titles' do
      expect(report.bill)
        .to include('Timing belts change', 'Timing belt',
                    'Water pump', 'Bearing')
    end

    it 'total price must be 300' do
      expect(report.bill.values).to eq_array_sum(300)
    end
  end

  context 'generating bill with discount' do
    let(:tires_change) do
      Job.new(title: 'Tires change', price: 20)
    end

    let(:tires) do
      Part.new(title: 'Tire', quantity: 4, prime_price: 80, client_price: 95)
    end

    before(:each) do
      report.add_completed_job(tires_change)
      report.add_used_part(tires)
    end

    it 'total price must be 320' do
      bill = report.bill { |price| price * 0.8 }
      expect(bill.values).to eq_array_sum(320)
    end

    it 'must apply discount for tires change and tires price' do
      expect { |b| report.bill(&b) }.to yield_successive_args(20, 380)
    end
  end

  context 'setting car mileage' do
    it 'must return exactly what was set' do
      report.car_mileage = 150_000
      expect(report.car_mileage).to eq(150_000)
    end

    it 'must do not set less than 0' do
      report.car_mileage = -1
      expect(report.car_mileage).to be_nil
    end

    it 'must allow 0' do
      report.car_mileage = 0
      expect(report.car_mileage).to eq(0)
    end
  end

  context 'setting the comment' do
    it 'must return exactly what was set' do
      report.comment = 'very unclean'
      expect(report.comment).to eq('very unclean')
    end

    it 'must do not set empty comment' do
      report.comment = ''
      expect(report.comment).to be_nil
    end
  end

  context 'prime price' do
    let(:injector) do
      Part.new(title: 'Injector', quantity: 4, prime_price: 110, client_price: 150)
    end

    let(:fuel_filter) do
      Part.new(title: 'Fuel filter', quantity: 1, prime_price: 60, client_price: 70)
    end

    context 'with no parts' do
      it 'must return zero' do
        expect(report.parts_total_prime_price).to eq(0)
      end
    end

    context 'with parts added' do
      before(:each) do
        report.add_used_part(injector)
        report.add_used_part(fuel_filter)
      end

      it 'must return the total prime price of the added parts' do
        expect(report.parts_total_prime_price).to eq(500)
      end

      it 'must call job total prime price on injector once' do
        expect(injector).to receive(:total_prime_price).once.and_call_original
        report.parts_total_prime_price
      end

      it 'must call job total prime price on fuel_filter once' do
        expect(fuel_filter).to receive(:total_prime_price).once.and_call_original
        report.parts_total_prime_price
      end

      it 'must do not call job total price on injector' do
        expect(injector).to_not receive(:total_price)
        report.parts_total_prime_price
      end

      it 'must do not call job total price on fuel_filter' do
        expect(fuel_filter).to_not receive(:total_price)
        report.parts_total_prime_price
      end
    end
  end
end
