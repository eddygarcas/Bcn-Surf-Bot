require 'yaml'
require 'logger'

class ConfigHelper

  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::INFO

  @@config_yaml = YAML.load_file 'config/config.yml'

  def self.config(tag)
    @@config_yaml[tag]
  end

  def self.action_spots?(message)
    config(:actions)[:spots].include?(message.query.to_s.downcase)
  end

  def self.log(message)
    location = config(:spots)[message.query.to_s.downcase]
    @@logger.info(
        "MswHttpSearch #{message.from.username} id.#{message.from.id} for #{location[:name]} code #{location[:id]} at #{Time.now} from #{message.from.language_code}"
    )
  end

end