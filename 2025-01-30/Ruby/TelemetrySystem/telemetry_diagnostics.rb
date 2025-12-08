require './telemetry_client'

class TelemetryDiagnostics
  attr_reader :diagnostic_info
  DIAGNOSTIC_CHANNEL_CONNECTION_STRING = "*111#"
  
  def initialize
    @telemetry_client = TelemetryClient.new(DIAGNOSTIC_CHANNEL_CONNECTION_STRING)
    @diagnostic_info = "foo"
  end

  def check_transmission
    @telemetry_client.connect
    @telemetry_client.send(TelemetryClient::DIAGNOSTIC_MESSAGE)
    @diagnostic_info = @telemetry_client.receive
  end
end
