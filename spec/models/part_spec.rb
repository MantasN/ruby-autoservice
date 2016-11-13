require 'rails_helper'

describe Part, :type => :model do
  fixtures :all

  let(:part) do
    parts(:air_filter)
  end

  context 'when it was created' do
    it 'must be able to return title' do
      expect(part.title).to eq('Air filter')
    end

    it 'must be able to return quantity' do
      expect(part.quantity).to eq(3)
    end

    it 'must be able to return prime price' do
      expect(part.prime_price).to eq(15)
    end

    it 'must be able to return client price' do
      expect(part.client_price).to eq(20)
    end
  end

  context 'calculating prices' do
    it 'total prime price must be 45' do
      expect(part.total_prime_price).to eq(45)
    end

    it 'total price must be 60' do
      expect(part.total_price).to eq(60)
    end
  end
end
