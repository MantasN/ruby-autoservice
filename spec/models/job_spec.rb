require 'rails_helper'

describe Job, :type => :model do
  fixtures :all

  let(:job) do
    jobs(:air_filter)
  end

  context 'when it was created' do
    it 'must be able to return title' do
      expect(job.title).to eq('Air filter change')
    end

    it 'must be able to return price' do
      expect(job.price).to eq(20)
    end
  end
end
