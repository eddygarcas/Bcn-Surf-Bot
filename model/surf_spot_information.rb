require_relative '../utils/data_builder'

class SurfSpotInformation < DataBuilder

  VALID_FIELDS = ['localTimestamp', 'unit', 'swell', 'components', 'combined', 'height', 'period', 'direction', 'compassDirection','wind','speed']

  attr_accessor :latitude, :longitude, :name

  def initialize(net, location = nil)
    net.each do |k, v|
      if VALID_FIELDS.include?(k)
        if v.is_a?(Hash)
          initialize v
        else
          accesor_builder k, v
        end
      end
    end

    unless location.nil?
      @latitude = location[:latitude]
      @longitude = location[:longitude]
      @name = location[:name]
    end

  end

  def now?
    local_converted = Time.at(@localTimestamp)
    return false unless local_converted.day.equal?(Time.now.day)
    ((local_converted.hour <=> Time.now.hour)).equal?(1)
  end

  def to_s
    %Q{Swell #{height}m at #{period}s Dir.#{compassDirection}\n Wind #{speed}kph Time #{format_time}}
  end

  private

  def format_time
    Time.at(localTimestamp).strftime(" at %I:%M%p")
  end
end
