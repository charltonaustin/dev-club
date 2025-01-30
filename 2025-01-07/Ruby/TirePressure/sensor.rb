class Sensor
  OFFSET = 16

  def initialize(random_generator = Random.new)
    @random_generator = random_generator
  end
    
  def pop_next_pressure_psi_value
    OFFSET +  6 * @random_generator.rand * @random_generator.rand
  end
end