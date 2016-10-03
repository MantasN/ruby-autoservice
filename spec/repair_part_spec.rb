require 'rspec'
require 'repair_part'

describe RepairPart do
  let(:repair_part) do
    described_class.new('Air filter', 3, 15, 20)
  end

  context 'when it was created' do
    it 'must be able to return title' do
      expect(repair_part.title).to eq('Air filter')
    end

    it 'must be able to return quantity' do
      expect(repair_part.quantity).to eq(3)
    end

    it 'must be able to return prime price' do
      expect(repair_part.prime_price).to eq(15)
    end

    it 'must be able to return client price' do
      expect(repair_part.client_price).to eq(20)
    end
  end

  context 'calculating prices' do
    it 'total prime price must be 45' do
      expect(repair_part.total_prime_price).to eq(45)
    end

    it 'total price must be 60' do
      expect(repair_part.total_price).to eq(60)
    end
  end
end
