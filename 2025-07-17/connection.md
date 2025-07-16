brew install dnsmasq
sudo brew services start dnsmasq
echo address=/kafka-serverless.us-east-2.amazonaws.com/127.0.0.1 >> $(brew --prefix)/etc/dnsmasq.conf
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
dscacheutil -flushcache
sudo mkdir -p /etc/resolver

sudo tee /etc/resolver/kafka-serverless.us-east-2.amazonaws.com >/dev/null <<EOF
nameserver 127.0.0.1
EOF

--


ssh -i dev-club-key.pem -L 9098:boot-pieclbrb.c1.kafka-serverless.us-east-2.amazonaws.com:9098 -N ec2-user@ec2-18-226-163-91.us-east-2.compute.amazonaws.com

--

TEMP_CREDS=$(aws sts assume-role \
 --role-arn arn:aws:iam::863647765358:role/dev-club-msk-serverless-bastion-role \
 --role-session-name fresh-kafka-session \
 --profile sandboxplatform)

export AWS_SESSION_TOKEN=$(echo $TEMP_CREDS | jq -r '.Credentials.SessionToken')
export AWS_SECRET_ACCESS_KEY=$(echo $TEMP_CREDS | jq -r '.Credentials.SecretAccessKey')
export AWS_ACCESS_KEY_ID=$(echo $TEMP_CREDS | jq -r '.Credentials.AccessKeyId')

./bin/kafka-topics.sh --list --bootstrap-server boot-pieclbrb.c1.kafka-serverless.us-east-2.amazonaws.com:9098 --command-config client.properties

./bin/kafka-console-producer.sh \
 --topic test \
 --bootstrap-server boot-pieclbrb.c1.kafka-serverless.us-east-2.amazonaws.com:9098 \
 --producer.config client.properties

./bin/kafka-console-consumer.sh \
 --topic test \
 --group test-group \
 --bootstrap-server boot-pieclbrb.c1.kafka-serverless.us-east-2.amazonaws.com:9098 \
 --consumer.config client.properties \
 --property "print.key=true" \
 --property "key.separator=:" \
 --from-beginning
