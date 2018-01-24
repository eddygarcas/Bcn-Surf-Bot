require_relative '../utils/data_builder'

class SurfSpotInformation < DataBuilder

  VALID_FIELDS = ['localTimestamp', 'unit', 'swell', 'components', 'combined', 'height', 'period', 'direction', 'compassDirection', 'wind', 'speed', 'charts']

  attr_accessor :latitude, :longitude, :name

  def initialize(elem, location = nil)
    parse_spot elem
    parse_location location
  end

  def now?
    ((Time.at(@localTimestamp) <=> Time.now)).equal?(1)
  end

  def to_s
    %Q{Swell #{height}m at #{period}s Dir #{compassDirection}\nWind #{speed}kph #{format_time}}
  end

  protected

  def format_time
    Time.at(localTimestamp).strftime("at %d/%m/%y %I:%M%p")
  end

  private

  def parse_spot elem
    elem.each do |k, v|
      if VALID_FIELDS.include?(k)
        if !v.is_a?(Hash) || k.eql?(:charts.to_s)
          accesor_builder k, v
        else
          initialize v
        end
      end
    end
  end

  def parse_location(location)
    unless location.nil?
      @latitude = location[:latitude]
      @longitude = location[:longitude]
      @name = location[:name]
    end
  end

end
