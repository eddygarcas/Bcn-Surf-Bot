require 'yaml'
require 'logger'

class ConfigHelper

  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO

  @@config_yaml = YAML.load_file 'config/config.yml'

  def self.config(tag)
    @@config_yaml[tag]
  end

  # def include?(tag)
  #   return false if @@config_yaml[tag.to_s].nil?
  #   return true if @@config_yaml[tag.to_s].is_a?(Hash)
  #   @@config_yaml[tag.to_s].select {|k,v| k.eql?}
  #
  # end

end