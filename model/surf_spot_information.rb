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
    %Q{#{name} Swell #{height}m at #{period}s Dir #{compassDirection}\nWind #{speed}kph #{format_time}}
  end

  def to_html
    %Q{<b>#{name}</b> <pre>Swell #{height}m at #{period}s Dir #{compassDirection} Wind #{speed}kph #{format_time}</pre> <a href='#{charts[:swell.to_s]}'>Chart #{format_time}</a> }
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
