require 'rails_helper'

describe Detail, :type => :model do
  fixtures :all

  context 'when requesting string representation' do
    it 'returns formatted string with reason, car and owner' do
      expect(details(:detail).to_s)
        .to eq('[Reason: need to change tires; ' \
'Car: VW GOLF 6; Owner: Mantas Neviera]')
    end
  end
end
