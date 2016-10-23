require 'yaml'
require 'fileutils'

# This class provides the possibility to store and retrieve data using yaml files
class DataRepository
  def initialize(db_path)
    @db_path = db_path
  end

  def save_data(data)
    FileUtils.mkdir_p(@db_path) unless File.exist?(@db_path)
    File.open(db_file_path, 'a+') { |file| file.write(YAML.dump(data)) }
  end

  def load_data
    YAML.load File.read(db_file_path) if File.exist?(db_file_path)
  end

  def db_file_path
    "#{@db_path}/db.yaml"
  end
end
