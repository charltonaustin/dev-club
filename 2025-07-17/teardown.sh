
#!/bin/bash

# Cleanup DNS masquerading for Kafka serverless
# This script reverses all changes made by setup.sh

set -e  # Exit on any error

echo "Cleaning up DNS masquerading for Kafka serverless..."

# Remove address mapping from dnsmasq config
echo "Removing address mapping from dnsmasq config..."
sed -i '' '/address=\/kafka-serverless.us-east-2.amazonaws.com\/127.0.0.1/d' $(brew --prefix)/etc/dnsmasq.conf

# Uninstall dnsmasq
echo "Uninstalling dnsmasq..."
brew uninstall dnsmasq

# Flush DNS cache
echo "Flushing DNS cache..."
dscacheutil -flushcache

# Execute all sudo commands in a single block
echo "Executing cleanup commands that require sudo..."
sudo bash -c '
echo "Removing resolver config..."
rm -f /etc/resolver/kafka-serverless.us-east-2.amazonaws.com

echo "Stopping dnsmasq service..."
brew services stop dnsmasq

echo "Unloading dnsmasq service..."
launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist 2>/dev/null || true
'

echo "Cleanup complete!"
echo "All DNS masquerading configuration has been removed."