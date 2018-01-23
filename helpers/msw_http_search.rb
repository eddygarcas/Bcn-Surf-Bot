require 'httparty'
require_relative '../model/surf_spot_information'
require 'pp'
require 'date'

class MswHttpSearch
  include HTTParty

  format :json

  def get_spot(location, fields = '')
    return raise ArgumentError.new('Missing field location') if location.nil?
    self.class.base_uri ENV[:MSW_API.to_s]
    response = self.class.get('/forecast', query: {spot_id: location[:id], units: location[:units], fields: fields})
    parse_response(response, location)
  end

  private

  def parse_response(response, location)
    candidates = []
    JSON.parse(response.body).each { |elem|
      raise StandardError.new(elem[1][:error_msg.to_s]) if error?(elem)
      candidates << SurfSpotInformation.new(elem, location)
    }
    #Use symbols as procs when possible. & it's the same as a block like {|elem| }
    #the symbol represents the method to call ans should exist.
    candidates.select(&:now?)
  end

  def error?(elem)
    elem[0].eql?(:error_response.to_s)
  end

end
