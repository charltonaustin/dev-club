require_relative '../sensor'
describe Sensor do
  context "#pop_next_pressure_psi_value" do
    it "returns a random number lower than 17 " do
      random = double("random") 
      allow(random).to receive(:rand).and_return(0.001, 0.001)
      sensor = Sensor.new(random)
      expect(sensor.pop_next_pressure_psi_value).to be < 17
    end

    it "returns a random number higher than 21 " do
      random = double("random") 
      allow(random).to receive(:rand).and_return(2.0, 2.0)
      sensor = Sensor.new(random)
      expect(sensor.pop_next_pressure_psi_value).to be > 21
    end

    it "returns a random between 17 and 21 " do
      random = double("random") 
      allow(random).to receive(:rand).and_return(1.0, 0.5)
      sensor = Sensor.new(random)
      expect(sensor.pop_next_pressure_psi_value).to eq(19)
    end
  end
end