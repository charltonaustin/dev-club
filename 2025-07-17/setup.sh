#!/bin/bash

# Setup DNS masquerading for Kafka serverless
# This script requires sudo access and will prompt for password once

set -e  # Exit on any error

echo "Setting up DNS masqueraging for Kafka serverless..."

echo "Installing jd"
brew install jd

# Install dnsmasq if not already installed
echo "Installing dnsmasq..."
brew install dnsmasq

# Add address mapping to dnsmasq config
echo "Adding address mapping to dnsmasq config..."
echo "address=/kafka-serverless.us-east-2.amazonaws.com/127.0.0.1" >> $(brew --prefix)/etc/dnsmasq.conf

# Flush DNS cache
echo "Flushing DNS cache..."
dscacheutil -flushcache

# Authenticate sudo once and run all sudo commands in a single session
echo "Running sudo commands (will prompt for password once)..."
sudo bash << 'SUDO_COMMANDS'
# Start dnsmasq service
echo "Starting dnsmasq service..."
brew services start dnsmasq

# Reload dnsmasq service
echo "Reloading dnsmasq service..."
launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist 2>/dev/null || true
launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

# Create resolver directory
echo "Creating resolver directory..."
mkdir -p /etc/resolver

# Create resolver config file
echo "Creating resolver config..."
tee /etc/resolver/kafka-serverless.us-east-2.amazonaws.com >/dev/null <<EOF
nameserver 127.0.0.1
EOF
SUDO_COMMANDS

echo "DNS setup complete!"
echo "You can now run the SSH tunnel and Kafka commands."
