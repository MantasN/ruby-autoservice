require 'rspec'
require 'data_repository'

describe DataRepository do
  PATH = 'test_tmp'.freeze

  let(:data_repository) do
    described_class.new(PATH)
  end

  let(:data) do
    %w(data1 data2)
  end

  after(:each) do
    FileUtils.rm_r(PATH) if File.exist?(PATH)
  end

  context 'when db file could not be found' do
    it 'must return nil' do
      expect(data_repository.load_data).to be_nil
    end
  end

  context 'when db file was found' do
    it 'must return exactly stored data' do
      data_repository.save_data(data)
      expect(data_repository.load_data).to eq(data)
    end
  end
end