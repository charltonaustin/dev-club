require "./TirePressure/tire_pressure"

RSpec.describe Alarm do
  describe "#is_alarm_on" do
    it "is off by default" do
      expect(described_class.new.is_alarm_on).to be_falsy
    end
  end

  describe "#check" do
    subject { described_class.new }
    let(:sensor) { instance_double(Sensor, pop_next_pressure_psi_value: psi_value) }

    before do
      allow(Sensor).to receive(:new).and_return(sensor)
      # allow(sensor).to receive(:pop_next_pressure_psi_value).and_return(psi_value)
    end

    context "pressure is outside bounds" do
      let(:psi_value) { 100 }

      it "sets alarm" do
        expect { subject.check }
          .to change { subject.is_alarm_on }
          .to true
      end
    end

    context "pressure is within bounds" do
      let(:psi_value) { 18 }

      it "does not set alarm" do
        expect { subject.check }
          .to_not change { subject.is_alarm_on }
      end
    end
  end
end
