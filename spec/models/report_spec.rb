require 'rails_helper'

RSpec::Matchers.define :eq_array_sum do |sum|
  match do |array|
    array.reduce(0, &:+) == sum
  end
end

describe Report, type: :model do
  fixtures :all

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
    before do
      report.add_completed_job(jobs(:brake_pad))
      report.add_used_part(parts(:brake_pad))
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
        .to yield_with_args(jobs(:brake_pad))
    end

    it 'must yield with added part' do
      expect { |b| report.foreach_used_part(&b) }
        .to yield_with_args(parts(:brake_pad))
    end
  end

  context 'job and used part were added and deleted' do
    before do
      report.add_completed_job(jobs(:brake_pad))
      report.add_used_part(parts(:brake_pad))
      report.remove_job(jobs(:brake_pad))
      report.remove_part(parts(:brake_pad))
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
    before do
      report.add_completed_job(jobs(:brake_pad))
      report.add_used_part(parts(:brake_pad))
      report.add_used_part(parts(:water_pump))
      report.add_used_part(parts(:bearing))
    end

    it 'must contain 4 items' do
      expect(report.bill.length).to eq(4)
    end

    it 'must contain exact titles' do
      expect(report.bill)
        .to include('Brake pads change', 'Brake pads',
                    'Water pump', 'Bearing')
    end

    it 'total price must be 240' do
      expect(report.bill.values).to eq_array_sum(240)
    end
  end

  context 'generating bill with discount' do
    before do
      report.add_completed_job(jobs(:brake_pad))
      report.add_used_part(parts(:brake_pad))
    end

    it 'total price must be 72' do
      bill = report.bill { |price| price * 0.8 }
      expect(bill.values).to eq_array_sum(72)
    end

    it 'must apply discount for job and parts price' do
      expect { |b| report.bill(&b) }.to yield_successive_args(50, 40)
    end
  end

  context 'setting car mileage' do
    it 'must return exactly what was set' do
      report.car_mileage = 150_000
      expect(report.car_mileage).to eq(150_000)
    end
  end

  context 'setting the comment' do
    it 'must return exactly what was set' do
      report.comment = 'very unclean'
      expect(report.comment).to eq('very unclean')
    end
  end

  context 'prime price' do
    context 'with no parts' do
      it 'must return zero' do
        expect(report.parts_total_prime_price).to eq(0)
      end
    end

    context 'with parts added' do
      before do
        report.add_used_part(parts(:brake_pad))
        report.add_used_part(parts(:air_filter))
      end

      it 'must return the total prime price of the added parts' do
        expect(report.parts_total_prime_price).to eq(65)
      end

      it 'must call job total prime price on brake pad once' do
        expect(parts(:brake_pad))
          .to receive(:total_prime_price).once.and_call_original
        report.parts_total_prime_price
      end

      it 'must call job total prime price on air filter once' do
        expect(parts(:air_filter))
          .to receive(:total_prime_price).once.and_call_original
        report.parts_total_prime_price
      end

      it 'must do not call job total price on brake pad' do
        expect(parts(:brake_pad)).not_to receive(:total_price)
        report.parts_total_prime_price
      end

      it 'must do not call job total price on air filter' do
        expect(parts(:air_filter)).not_to receive(:total_price)
        report.parts_total_prime_price
      end
    end
  end
end
