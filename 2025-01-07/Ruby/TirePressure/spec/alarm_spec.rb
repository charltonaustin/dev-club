require_relative '../alarm'
describe Alarm do
  context "#check" do
    it "alarm is on if psi value is lower than minimum" do
      sensor = double("sensor")
      allow(sensor).to receive(:pop_next_pressure_psi_value).and_return(16)
      alarm = Alarm.new(sensor)

      alarm.check
      expect(alarm.is_on).to eq(true)
    end

    it "alarm is on if psi value is higher than maximum" do
      sensor = double("sensor")
      allow(sensor).to receive(:pop_next_pressure_psi_value).and_return(22)
      alarm = Alarm.new(sensor)

      alarm.check
      expect(alarm.is_on).to eq(true)
    end

    it "alarm is off if psi value is between minimum and maximum" do
      sensor = double("sensor")
      allow(sensor).to receive(:pop_next_pressure_psi_value).and_return(19)
      alarm = Alarm.new(sensor)

      alarm.check
      expect(alarm.is_on).to eq(false)
    end
  end
end
