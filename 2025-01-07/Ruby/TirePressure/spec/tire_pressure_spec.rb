require_relative '../tire_pressure'

describe Alarm do
  describe "#initialize" do
    context "when a sensor is passed in" do
      it "does not instantiate a Sensor" do
        expect(Sensor).not_to receive(:new)

        described_class.new(sensor: true)
      end
    end

    context "when a sensor is not passed in" do
      it "instantiates a Sensor" do
        expect(Sensor).to receive(:new)

        described_class.new
      end
    end
  end

  describe "#check" do
    subject { described_class.new(sensor:) }

    let(:sensor_reading) { 0 }
    let(:sensor) { instance_double(Sensor, pop_next_pressure_psi_value: sensor_reading) }

    context "when the pressure is too low" do
      let(:sensor_reading) { 16 }

      it "should have the alarm on" do
        subject.check
        expect(subject.is_alarm_on).to be true
      end
    end

    context "when the pressure is at the low pressure threshold" do
      let(:sensor_reading) { 17 }

      it "should have the alarm off" do
        subject.check
        expect(subject.is_alarm_on).to be false
      end
    end

    context "when the pressure is between the low and high pressure thresholds" do
      let(:sensor_reading) { 18 }

      it "should have the alarm off" do
        subject.check
        expect(subject.is_alarm_on).to be false
      end
    end

    context "when the pressure is at the high pressure threshold" do
      let(:sensor_reading) { 21 }

      it "should have the alarm off" do
        subject.check
        expect(subject.is_alarm_on).to be false
      end
    end

    context "when the pressure is above the high pressure threshold" do
      let(:sensor_reading) { 22 }

      it "should have the alarm on" do
        subject.check
        expect(subject.is_alarm_on).to be true
      end
    end
  end
end
