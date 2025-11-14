require_relative 'sensor'

class Alarm


  attr_reader :is_on

  def initialize(sensor = Sensor.new())
    @low_pressure_threshold = 17
    @high_pressure_threshold = 21
    @sensor = sensor
    @is_on = false
  end
      
  def check
    psi_pressure_value = @sensor.pop_next_pressure_psi_value()
    
    @is_on = (psi_pressure_value < @low_pressure_threshold or @high_pressure_threshold < psi_pressure_value)
  end
end