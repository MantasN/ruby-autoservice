require 'rspec'
require 'repair_details'

describe RepairDetails do
  let(:repair_details) do
    described_class.new('need to change tires', 'VW GOLF 6', 'Mantas Neviera')
  end

  context 'when requesting string representation' do
    it 'returns formatted string with car and owner' do
      expect(repair_details.to_s)
        .to eq("[Reason: #{repair_details.reason}; " \
"Car: #{repair_details.car}; Owner: #{repair_details.owner}]")
    end
  end
end
