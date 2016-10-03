require 'rspec'
require 'repair_report'
require 'repair_job'
require 'repair_part'

describe RepairReport do
  let(:repair_report) do
    described_class.new
  end

  context 'just after creation' do
    it 'completed jobs count must be 0' do
      expect(repair_report.completed_jobs_count).to eq(0)
    end

    it 'used parts count must be 0' do
      expect(repair_report.used_parts_count).to eq(0)
    end

    it 'must not yield when completed jobs list is empty' do
      expect { |b| repair_report.foreach_completed_job(&b) }
        .not_to yield_control
    end

    it 'must not yield when used parts list is empty' do
      expect { |b| repair_report.foreach_used_part(&b) }
        .not_to yield_control
    end

    it 'the total price must be 0' do
      expect(repair_report.total_price).to eq(0)
    end

    it 'bill must contain 0 items' do
      expect(repair_report.bill.length).to eq(0)
    end

    it 'car mileage must be nil' do
      expect(repair_report.car_mileage).to be_nil
    end

    it 'comment must be nil' do
      expect(repair_report.comment).to be_nil
    end
  end

  context 'job and used part were added' do
    let(:brake_pads_job) do
      RepairJob.new('Brake pads change', 50)
    end

    let(:brake_pad_part) do
      RepairPart.new('Brake pads', 2, 10, 20)
    end

    before(:each) do
      repair_report.add_completed_job(brake_pads_job)
      repair_report.add_used_part(brake_pad_part)
    end

    it 'must return 1 for the completed jobs count' do
      expect(repair_report.completed_jobs_count).to eq(1)
    end

    it 'must return 2 for the used parts count' do
      expect(repair_report.used_parts_count).to eq(2)
    end

    it 'must return 60 for the total price' do
      expect(repair_report.total_price).to eq(90)
    end

    it 'must yield with added job' do
      expect { |b| repair_report.foreach_completed_job(&b) }
        .to yield_with_args(brake_pads_job)
    end

    it 'must yield with added part' do
      expect { |b| repair_report.foreach_used_part(&b) }
        .to yield_with_args(brake_pad_part)
    end
  end

  context 'job and used part were added and deleted' do
    before(:each) do
      repair_report.add_completed_job(RepairJob.new('Oil change', 15))
      repair_report.add_used_part(RepairPart.new('Oil', 1, 20, 25))
      repair_report.remove_job_at_position(0)
      repair_report.remove_part_at_position(0)
    end

    it 'must return 0 for the completed jobs count' do
      expect(repair_report.completed_jobs_count).to eq(0)
    end

    it 'must return 0 for the used parts count' do
      expect(repair_report.used_parts_count).to eq(0)
    end

    it 'must return 0 for the total price' do
      expect(repair_report.total_price).to eq(0)
    end
  end

  context 'generating bill' do
    before(:each) do
      repair_report.add_completed_job(RepairJob.new('Timing belts change', 110))
      repair_report.add_used_part(RepairPart.new('Timing belt', 1, 30, 40))
      repair_report.add_used_part(RepairPart.new('Water pump', 1, 50, 70))
      repair_report.add_used_part(RepairPart.new('Bearing', 2, 25, 40))
    end

    it 'must contain 4 items' do
      expect(repair_report.bill.length).to eq(4)
    end

    it 'total price must be 300' do
      expect(repair_report.bill.values.reduce(0, &:+)).to eq(300)
    end
  end

  context 'generating bill with discount' do
    before(:each) do
      repair_report.add_completed_job(RepairJob.new('Tires change', 20))
      repair_report.add_used_part(RepairPart.new('Tire', 4, 80, 95))
    end

    it 'total price must be 320' do
      bill = repair_report.bill { |price| price * 0.8 }
      expect(bill.values.reduce(0, &:+)).to eq(320)
    end

    it 'must apply discount for tires change and tires price' do
      expect { |b| repair_report.bill(&b) }.to yield_successive_args(20, 380)
    end
  end

  context 'setting car mileage' do
    it 'must return exactly what was set' do
      repair_report.car_mileage = 150_000
      expect(repair_report.car_mileage).to eq(150_000)
    end

    it 'must do not set less than 0' do
      repair_report.car_mileage = -1
      expect(repair_report.car_mileage).to be_nil
    end
  end

  context 'setting the comment' do
    it 'must return exactly what was set' do
      repair_report.comment = 'very unclean'
      expect(repair_report.comment).to eq('very unclean')
    end

    it 'must do not set empty comment' do
      repair_report.comment = ''
      expect(repair_report.comment).to be_nil
    end
  end

  context 'prime price' do
    it 'must return zero if no parts was added' do
      expect(repair_report.parts_total_prime_price).to eq(0)
    end

    it 'must return the total prime price of the added parts' do
      repair_report.add_used_part(RepairPart.new('Injector', 4, 110, 150))
      repair_report.add_used_part(RepairPart.new('Fuel filter', 1, 60, 70))
      expect(repair_report.parts_total_prime_price).to eq(500)
    end
  end
end
