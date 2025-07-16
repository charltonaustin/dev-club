#!/usr/bin/env ruby

require 'rdkafka'
require 'json'
require 'time'
require 'securerandom'
require 'aws_msk_iam_sasl_signer'

# Check if AWS credentials are set
unless ENV['AWS_ACCESS_KEY_ID'] && ENV['AWS_SECRET_ACCESS_KEY']
  puts "❌ AWS credentials not found. Please run: source ../export_aws_creds.sh"
  exit 1
end

# Check session token (warn if missing but don't fail)
unless ENV['AWS_SESSION_TOKEN'] && ENV['AWS_SESSION_TOKEN'].length > 10
  puts "⚠️  Warning: AWS_SESSION_TOKEN not found or too short. This may be required for MSK IAM."
end

puts "🚀 Ruby Kafka Producer (rdkafka + aws-msk-iam-sasl-signer)"
puts "📡 Connecting to MSK IAM authenticated cluster..."
puts "💎 Using pure Ruby implementation for MSK IAM authentication"

class MSKProducer
  def initialize
    @clients = {}
    @region = 'us-east-2' # MSK cluster region
  end
  
  def self.start!(kafka_config)
    Rdkafka::Config.oauthbearer_token_refresh_callback = method(:refresh_token)
    @producer = Rdkafka::Config.new(kafka_config).producer(native_kafka_auto_start: false)
    @clients[@producer.name] = @producer
    puts "📝 Producer registered with name: #{@producer.name}"
    @producer.start
    @producer
  end
  
  def self.refresh_token(client_name, _unused_arg = nil)
    puts "🔄 OAuth token refresh callback triggered for client: '#{client_name}'"
    puts "📋 Available clients: #{@clients.keys.inspect}"
    begin
      signer = AwsMskIamSaslSigner::MSKTokenProvider.new(region: 'us-east-2')
      token = signer.generate_auth_token
      puts "✅ Token generated successfully"
      
      client = @clients[client_name]
      if client
        client.oauthbearer_set_token(
          token: token.token,
          lifetime_ms: token.expiration_time_ms,
          principal_name: 'kafka-cluster'
        )
        puts "✅ Token set successfully on client"
      else
        puts "❌ Client not found: '#{client_name}'"
        puts "🔍 Trying with first available client..."
        client = @clients.values.first
        if client
          client.oauthbearer_set_token(
            token: token.token,
            lifetime_ms: token.expiration_time_ms,
            principal_name: 'kafka-cluster'
          )
          puts "✅ Token set on first available client"
        end
      end
    rescue => e
      puts "❌ Token refresh failed: #{e.message}"
      client = @clients[client_name] || @clients.values.first
      client&.oauthbearer_set_token_failure("Token refresh failed: #{e.message}")
    end
  end
  
  def self.from_name(client_name)
    @clients[client_name]
  end
  
  # Initialize class variables
  @clients = {}
  @producer = nil
end

def create_rdkafka_config
  {
    :"bootstrap.servers" => 'boot-pieclbrb.c1.kafka-serverless.us-east-2.amazonaws.com:9098',
    :"client.id" => 'ruby-rdkafka-producer',
    :"security.protocol" => 'SASL_SSL',
    :"sasl.mechanism" => 'OAUTHBEARER',
    :"ssl.ca.location" => nil, # Use system certs
    :"enable.ssl.certificate.verification" => false,
    :"log_level" => 3, # Info level
  }
end

TOPIC_NAME = ENV.fetch('KAFKA_TOPIC', 'test')

def create_message(content)
  {
    id: SecureRandom.uuid,
    timestamp: Time.now.iso8601,
    source: 'ruby-producer-rdkafka',
    type: 'test-message',
    data: {
      content: content,
      environment: 'dev-club',
      producer_type: 'rdkafka_ruby_native'
    }
  }
end

def produce_messages
  puts "🔧 Initializing rdkafka producer with MSK IAM..."
  
  begin
    config = create_rdkafka_config
    producer = MSKProducer.start!(config)
    
    puts "✅ Connected to Kafka cluster"
    puts "📝 Topic: #{TOPIC_NAME}"
    puts
    
    # Send a few test messages
    messages = [
      "Hello from Pure Ruby Producer! 🎉",
    ]
    
    messages.each_with_index do |content, index|
      message = create_message(content)
      
      puts "📤 Sending message #{index + 1}:"
      puts "   Content: #{content}"
      puts "   Message ID: #{message[:id]}"
      
      delivery_report = producer.produce(
        topic: TOPIC_NAME,
        payload: JSON.generate(message),
        key: message[:id]
      )
      
      puts "✅ Message queued"
      
      # Wait for delivery confirmation
      puts "⏳ Waiting for delivery confirmation..."
      begin
        delivery_report.wait(max_wait_timeout: 10) # Increased timeout
        puts "✅ Message delivered successfully!"
        puts "   Topic: #{delivery_report.topic}" if delivery_report.respond_to?(:topic)
      rescue => delivery_error
        puts "❌ Delivery failed: #{delivery_error.message}"
      end
      
      puts
      sleep(1) # Brief pause between messages
    end
    
    puts "🎉 All messages sent successfully!"
    
  rescue => error
    puts "❌ Error: #{error.message}"
    puts error.backtrace.first(5).map { |line| "   #{line}" }
    exit 1
  ensure
    producer&.close
  end
end

def main
  puts "Starting Pure Ruby Kafka Producer with rdkafka..."
  puts "Press Ctrl+C to stop"
  puts "=" * 50
  
  begin
    produce_messages
  rescue Interrupt
    puts "\n👋 Shutting down gracefully..."
  end
end

if __FILE__ == $0
  main
end
