require 'rspec'
require 'data_repository'
require 'repair_details'

describe DataRepository do
  DR_TEST_PATH = 'dr_test_tmp'.freeze

  let(:data_repository) do
    described_class.new(DR_TEST_PATH)
  end

  let(:data) do
    { key1: 'value1', key2: 'value2' }
  end

  after(:each) do
    FileUtils.rm_r(DR_TEST_PATH) if File.exist?(DR_TEST_PATH)
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
