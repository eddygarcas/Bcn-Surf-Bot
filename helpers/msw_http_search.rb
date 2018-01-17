require 'httparty' #Need to require gems not part of the original installation
require_relative '../model/surf_spot_information'
require 'pp'
require 'date'
require 'yaml'

class MswHttpSearch
  include HTTParty

  @@config_yaml = YAML.load_file 'config/config.yml'

  attr_reader :spot_now


  base_uri "http://magicseaweed.com/api/#{@@config_yaml[:key_api]}/"
  #q: request parameter of search
  #default_params fields: 'spot_id, shortDescription', q: 'search'
  format :json #could be XML also.

  def get_spot(id)
    response = self.class.get('/forecast', query: {spot_id: id})
    parse_response(response, @@config_yaml[id])
  end

  private

  def parse_response(response, location)
    JSON.parse(response.body).each { |elem|
      raise StandardError.new(elem[1][:error_msg.to_s]) if error?(elem)

      candidate = SurfSpotInformation.new(elem, location)
      return candidate if candidate.now?
    }
  end

  def error?(elem)
    elem[0].eql?(:error_response.to_s)
  end

end
