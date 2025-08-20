require "rspec"

require_relative 'tire_pressure'

describe Alarm do
  let(:alarm) { Alarm.new() }
  context "is_alarm_on default" do
    it "should be false" do
      expect(Alarm.new().is_alarm_on).to eq(false)
    end
  end

  describe "#check" do
    context "when tire pressure is too low" do
      it "should turn on the alarm" do
        allow_any_instance_of(Sensor).to receive(:pop_next_pressure_psi_value).and_return(16)
        alarm.check

        expect(alarm.is_alarm_on).to eq(true)
      end
    end

    context "when tire pressure is too high" do
      it "should turn on the alarm" do
        allow_any_instance_of(Sensor).to receive(:pop_next_pressure_psi_value).and_return(22)
        alarm.check

        expect(alarm.is_alarm_on).to eq(true)
      end
    end

    context "when tire pressure is within normal range" do
      it "should not turn on the alarm" do
        allow_any_instance_of(Sensor).to receive(:pop_next_pressure_psi_value).and_return(20)
        alarm.check

        expect(alarm.is_alarm_on).to eq(false)
      end
    end
  end


  # def test_alarm_off_by_default
  #   assert(!Alarm.new().is_alarm_on)
  # end
 
  # def check
  #   assert(Alarm.new().is_alarm_on)
  # end
end
