require 'httparty' #Need to require gems not part of the original installation
require_relative '../model/surf_spot_information'
require 'pp'
require 'date'
require 'yaml'

class MswHttpSearch
  include HTTParty

  @@config_yaml = YAML.load_file 'config/config.yml'

  attr_reader :spot_now

  def initialize
  end

  base_uri "http://magicseaweed.com/api/#{@@config_yaml[:key_api]}/"
  #q: request parameter of search
  #default_params fields: 'spot_id, shortDescription', q: 'search'
  format :json #could be XML also.

  def get_spot(id)
    response = self.class.get('/forecast', query: {spot_id: id})
    parse_response(response)
  end

  private

  def parse_response(response)
    parsed_response = JSON.parse(response.body)

    parsed_response.each { |elem|
      raise StandardError.new(elem[1][:error_msg.to_s]) if error?(elem)

      candidate = SurfSpotInformation.new(elem)
      return candidate if candidate.is_now?
    }


  end

  def error?(elem)
    elem[0].eql?(:error_response.to_s)
  end

end
