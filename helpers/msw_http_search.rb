require 'httparty'
require_relative '../model/surf_spot_information'
require 'pp'
require 'date'

class MswHttpSearch
  include HTTParty

  format :json

  def get_spot(location, fields)
    self.class.base_uri ENV[:MSW_API.to_s]
    response = self.class.get('/forecast', query: {spot_id: location[:id], units: location[:units], fields: fields})
    parse_response(response, location)
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
