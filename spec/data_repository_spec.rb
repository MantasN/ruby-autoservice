require 'rspec'
require 'data_repository'
require 'repair_details'

describe DataRepository do
  DR_TEST_PATH = 'spec/fixtures/data_repo_test'.freeze
  DR_TMP_TEST_PATH = 'spec/fixtures/data_repo_tmp_test'.freeze

  let(:dynamic_repo) do
    described_class.new(DR_TMP_TEST_PATH)
  end

  let(:data_repo) do
    described_class.new(DR_TEST_PATH)
  end

  let(:hash) do
    { key1: 'value1', key2: 'value2', key3: 'value3' }
  end

  after(:each) do
    FileUtils.rm_r(DR_TMP_TEST_PATH) if File.exist?(DR_TMP_TEST_PATH)
  end

  context 'when trying to load saved data' do
    it 'must return exactly stored data' do
      expect(data_repo.load_data).to eq(hash)
    end
  end

  context 'when db file could not be found' do
    it 'must return nil' do
      expect(dynamic_repo.load_data).to be_nil
    end
  end

  context 'when trying to save data' do
    it 'file content must be the same' do
      dynamic_repo.save_data(hash)
      dynamic_content = File.read(dynamic_repo.db_file_path)
      data_repo_content = File.read(data_repo.db_file_path)
      expect(dynamic_content).to eq(data_repo_content)
    end
  end
end
