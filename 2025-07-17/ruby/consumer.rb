#!/usr/bin/env ruby

require 'rdkafka'
require 'json'
require 'time'
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

puts "🚀 Ruby Kafka Consumer (rdkafka + aws-msk-iam-sasl-signer)"
puts "📡 Connecting to MSK IAM authenticated cluster..."
puts "💎 Using pure Ruby implementation for MSK IAM authentication"

class MSKConsumer
  def initialize
    @clients = {}
    @region = 'us-east-2' # MSK cluster region
  end
  
  def self.start!(kafka_config)
    Rdkafka::Config.oauthbearer_token_refresh_callback = method(:refresh_token)
    @consumer = Rdkafka::Config.new(kafka_config).consumer(native_kafka_auto_start: false)
    @clients[@consumer.name] = @consumer
    puts "📝 Consumer registered with name: #{@consumer.name}"
    @consumer.start
    @consumer
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
  @consumer = nil
end

def create_rdkafka_config
  {
    :"bootstrap.servers" => 'boot-pieclbrb.c1.kafka-serverless.us-east-2.amazonaws.com:9098',
    :"client.id" => 'ruby-rdkafka-consumer',
    :"group.id" => "ruby-rdkafka-consumer-group-#{Time.now.to_i}",
    :"security.protocol" => 'SASL_SSL',
    :"sasl.mechanism" => 'OAUTHBEARER',
    :"ssl.ca.location" => nil, # Use system certs
    :"enable.ssl.certificate.verification" => false,
    :"auto.offset.reset" => 'earliest',
    :"enable.auto.commit" => true,
    :"log_level" => 3, # Info level
  }
end

TOPIC_NAME = ENV.fetch('KAFKA_TOPIC', 'test')

def format_message_output(message)
  begin
    parsed_data = JSON.parse(message.payload)
    
    puts "📨 New message received:"
    puts "   🆔 Key: #{message.key || 'null'}"
    puts "   📍 Partition: #{message.partition}, Offset: #{message.offset}"
    puts "   ⏰ Timestamp: #{Time.at(message.timestamp).iso8601}" if message.timestamp
    puts "   📦 Message Data:"
    
    if parsed_data.is_a?(Hash)
      if parsed_data['id']
        puts "      🆔 ID: #{parsed_data['id']}"
      end
      if parsed_data['timestamp']
        puts "      🕐 Timestamp: #{parsed_data['timestamp']}"
      end
      if parsed_data['source']
        puts "      🏷️  Source: #{parsed_data['source']}"
      end
      if parsed_data['data'] && parsed_data['data']['content']
        puts "      💬 Content: #{parsed_data['data']['content']}"
      end
      if parsed_data['data'] && parsed_data['data']['producer_type']
        puts "      🔧 Producer Type: #{parsed_data['data']['producer_type']}"
      end
    else
      puts "      📄 Raw: #{parsed_data}"
    end
    
  rescue JSON::ParserError
    puts "📨 New message received:"
    puts "   🆔 Key: #{message.key || 'null'}"
    puts "   📍 Partition: #{message.partition}, Offset: #{message.offset}"
    puts "   ⏰ Timestamp: #{Time.at(message.timestamp).iso8601}" if message.timestamp
    puts "   📄 Raw payload: #{message.payload}"
  end
  
  puts ""
end

def consume_messages
  puts "🔧 Initializing rdkafka consumer with MSK IAM..."
  
  begin
    config = create_rdkafka_config
    consumer = MSKConsumer.start!(config)
    
    puts "✅ Connected to Kafka cluster"
    puts "📋 Subscribing to topic: #{TOPIC_NAME}"
    
    consumer.subscribe(TOPIC_NAME)
    
    puts "🎧 Starting to consume messages..."
    puts "⏰ Press Ctrl+C to stop consuming"
    puts "=" * 50
    puts ""
    
    # Handle graceful shutdown
    trap('INT') do
      puts "\n\n🛑 Shutting down consumer..."
      consumer.close
      puts "✅ Consumer stopped successfully"
      exit 0
    end
    
    # Start consuming messages
    consumer.each do |message|
      format_message_output(message)
    end
    
  rescue => error
    puts "❌ Error consuming messages: #{error.message}"
    puts "🔍 Details: #{error.backtrace.first(3).join(', ')}"
    exit 1
  ensure
    consumer&.close
    puts "🔌 Disconnected from Kafka"
  end
end

def main
  puts "Starting Pure Ruby Kafka Consumer with rdkafka..."
  puts "Press Ctrl+C to stop"
  puts "=" * 50
  
  begin
    consume_messages
  rescue Interrupt
    puts "\n👋 Shutting down gracefully..."
  end
end

if __FILE__ == $0
  main
end
