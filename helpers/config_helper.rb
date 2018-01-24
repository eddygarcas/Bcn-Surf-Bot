require 'yaml'
require 'logger'

class ConfigHelper

  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO

  @@config_yaml = YAML.load_file 'config/config.yml'

  def self.config(tag)
    @@config_yaml[tag]
  end

end