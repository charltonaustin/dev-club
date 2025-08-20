

class Sensor
  OFFSET = 16
    
  def pop_next_pressure_psi_value
    Sensor.OFFSET + self.sample_pressure()
  end

  def self.sample_pressure
    # placeholder implementation that simulate a real sensor in a real tire
    6 * rand * rand
  end

end

class Alarm

  attr_reader :is_alarm_on

  DEFAULT_LOW_PRESSURE_THRESHOLD = 17
  DEFAULT_HIGH_PRESSURE_THRESHOLD = 21

  def initialize(sensor: Sensor.new)
    @sensor = sensor
    @is_alarm_on = false
  end
      
  def check
    psi_pressure_value = @sensor.pop_next_pressure_psi_value
    if psi_pressure_value < low_pressure_threshold or high_pressure_threshold < psi_pressure_value
      @is_alarm_on = true
    end
  end

  private

  def low_pressure_threshold
    DEFAULT_LOW_PRESSURE_THRESHOLD
  end

  def high_pressure_threshold
    DEFAULT_HIGH_PRESSURE_THRESHOLD
  end
end
