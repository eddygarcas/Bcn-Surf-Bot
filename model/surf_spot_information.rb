require_relative '../utils/data_builder'

class SurfSpotInformation < DataBuilder

  VALID_FIELDS = ['localTimestamp', 'unit', 'swell','components','combined','height','period','direction','compassDirection']

  #attr_accessor :distance

  def initialize(net)
    net.each do |k, v|
      if VALID_FIELDS.include?(k)
        if v.is_a?(Hash)
          initialize v
        else
          accesor_builder k, v
        end
      end
    end
  end

  def is_now?
    local_converted = Time.at(@localTimestamp)
    time_now = Time.now

    if local_converted.day.equal?(time_now.day)
      ((local_converted.hour <=> time_now.hour)).equal?(1)
    end
  end
end
