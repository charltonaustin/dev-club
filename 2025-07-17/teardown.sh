
#!/bin/bash

# Cleanup DNS masquerading for Kafka serverless
# This script reverses all changes made by setup.sh

set -e  # Exit on any error

echo "Cleaning up DNS masquerading for Kafka serverless..."

# Authenticate sudo once at the beginning
sudo -v

# Remove resolver config file
echo "Removing resolver config..."
sudo rm -f /etc/resolver/kafka-serverless.us-east-2.amazonaws.com

# Remove address mapping from dnsmasq config
echo "Removing address mapping from dnsmasq config..."
sed -i '' '/address=\/kafka-serverless.us-east-2.amazonaws.com\/127.0.0.1/d' $(brew --prefix)/etc/dnsmasq.conf

# Stop dnsmasq service
echo "Stopping dnsmasq service..."
sudo brew services stop dnsmasq

# Unload dnsmasq service (if it was loaded)
echo "Unloading dnsmasq service..."
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist 2>/dev/null || true

# Uninstall dnsmasq
echo "Uninstalling dnsmasq..."
brew uninstall dnsmasq

# Flush DNS cache
echo "Flushing DNS cache..."
dscacheutil -flushcache

echo "Cleanup complete!"
echo "All DNS masquerading configuration has been removed."