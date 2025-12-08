require_relative '../telemetry_diagnostics'

describe TelemetryDiagnostics do
  context "#diagnostic_info" do
    it "returns the correct diagnostic info" do
      expect(TelemetryDiagnostics.new.diagnostic_info).to eq "foo"
    end
  end
  context  "#check_transmission" do
    it "returns an error message if false" do
      allow_any_instance_of(TelemetryClient).to receive(:connect).and_return(false)

      expect(TelemetryDiagnostics.new.check_transmission).to eq "foo"
    end
    it "if true, successfully connects to the client" do
      allow_any_instance_of(TelemetryClient).to receive(:connect).and_return(true)
      allow_any_instance_of(TelemetryClient).to receive(:receive).and_return("foo")

      expect_any_instance_of(TelemetryClient).to receive(:send).with(TelemetryClient::DIAGNOSTIC_MESSAGE)
      expect(TelemetryDiagnostics.new.check_transmission).to eq("foo")
    end
  end
end
