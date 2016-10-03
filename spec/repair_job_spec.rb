require 'rspec'
require 'repair_job'

describe RepairJob do
  let(:repair_job) do
    described_class.new('Air filter change', 20)
  end

  context 'when it was created' do
    it 'must be able to return title' do
      expect(repair_job.title).to eq('Air filter change')
    end

    it 'must be able to return price' do
      expect(repair_job.price).to eq(20)
    end
  end
end
