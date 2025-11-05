# Event-Driven Architecture (EDA) Exercise

A hands-on exercise to understand Event-Driven Architecture using Apache Kafka.

## Prerequisites

- Docker Desktop installed and running
- Node.js installed (v16+)

## Exercise Overview

This exercise demonstrates the core concepts of EDA:
1. **Producers** - Applications that publish events
2. **Consumers** - Applications that subscribe to and process events
3. **Consumer Groups** - How Kafka distributes work among multiple consumers
4. **Topics & Partitions** - How events are organized and scaled

## Setup

### 1. Start Kafka and Kafka UI

```bash
docker compose up -d
```

This starts:
- **Kafka**
- **Kafka UI** at http://localhost:8080

### 2. Install Dependencies

```bash
npm install
```

## Exercise Steps

### Part 1: Explore Kafka UI

1. Open http://localhost:8080 in your browser
2. Click on "local" cluster
3. Notice there are no topics yet

### Part 2: Run a Producer

Open a terminal and run:

```bash
npm run producer
```

**What's happening:**
- The producer connects to Kafka
- Creates a topic called `user-events` (auto-created)
- Each message simulates a user page view event

**In Kafka UI:**
- Go to Topics → `user-events`
- Watch messages appear in real-time
- Click on "Messages" to see the content

### Part 3: Run a Single Consumer

Open a **new terminal** and run:

```bash
npm run consumer consumer-group-1
```

**What's happening:**
- Consumer connects and joins `consumer-group-1`
- Reads all messages from the `user-events` topic
- Processes messages from all partitions

**Expected output:**
- You should see all messages being consumed
- Note the `partition` and `offset` for each message

Keep this consumer running, then run the producer again in another terminal. Watch the consumer receive messages in real-time!

### Part 4: Multiple Consumers in the Same Group

Open **two more terminals** and run:

**Terminal 2:**
```bash
npm run consumer consumer-group-2
```

**Terminal 3:**
```bash
npm run consumer consumer-group-2
```

Now run the producer again:
```bash
npm run producer
```

**What's happening:**
- Two consumers in the same group (`consumer-group-2`)
- Kafka distributes messages between them (load balancing)
- Each message is processed by only ONE consumer in the group

**Observe:**
- Each consumer processes different messages
- No message is processed twice within the same group
- Kafka automatically balances the workload

### Part 5: Multiple Consumers in Different Groups

Stop all consumers (Ctrl+C), then start:

**Terminal 1:**
```bash
npm run consumer analytics-team
```

**Terminal 2:**
```bash
npm run consumer notifications-team
```

Run the producer:
```bash
npm run producer
```

**What's happening:**
- Two consumers in different groups
- Each group receives ALL messages independently
- Perfect for different teams/services processing the same events

**Observe:**
- Both consumers receive the same messages
- Each group processes messages independently
- Great for multi-team scenarios (analytics, notifications, logging, etc.)

## Key Concepts Demonstrated

### 1. **Decoupling**
- Producer doesn't know about consumers
- Can add/remove consumers without changing producer
- Services are independent

### 2. **Scalability**
- Multiple consumers in same group = horizontal scaling
- Kafka distributes load automatically
- Add more consumers to handle more load

### 3. **Flexibility**
- Multiple consumer groups = multiple use cases for same events
- Each team can process events their own way
- No need to duplicate event production

### 4. **Durability**
- Messages are persisted in Kafka
- Consumers can fail and resume from last offset
- No message loss

## Experiments

### 1. Create a topic manually in Kafka UI before running producer
   - Add multiple partitions (try 3-5 partitions)
   - See how messages distribute across partitions

**Questions to explore:**
- When you run the producer, which partitions receive messages?
- Do all partitions get an equal number of messages? Why or why not?
- What determines which partition a message goes to? (Hint: look at the message key)
- What happens if you create a topic with only 1 partition vs 5 partitions?

### 2. Stop a consumer mid-processing
   - Start it again
   - Notice it resumes from where it left off (offset management)

**Questions to explore:**
- What offset did the consumer stop at?
- When you restart, does it re-process the same messages or skip to new ones?
- What happens if you change the consumer group ID before restarting?
- Where does Kafka store the offset information?
- What would happen if offset tracking didn't exist?

### 3. Scale up consumers in the same group
   - Add 3-4 consumers in `consumer-group-1`
   - Run producer
   - Watch how Kafka rebalances partitions

**Questions to explore:**
- How did Kafka distribute partitions among the consumers?
- Does each consumer process every message or only some messages?
- What happens when you add a 5th consumer but only have 3 partitions?
- What happens when you stop one consumer - how do the remaining consumers adjust?
- Can you see the rebalancing happen in real-time?

### 4. Modify the producer to send different types of events
   - Order placed
   - User signup
   - Payment processed

**Questions to explore:**
- How did you modify the event structure?
- Did you keep the existing actions or create new ones?
- How would you ensure order-related events from the same order stay in sequence?
- What message key would you use for different event types?
- How does the choice of message key affect partition distribution?

### 5. Modify the consumer to process events differently
   - Filter specific events
   - Aggregate data
   - Forward to another system

**Questions to explore:**
- What filtering logic did you implement? (e.g., only process "purchase" events)
- If aggregating data, what are you counting/summing?
- How would you track state between messages (e.g., count total purchases per user)?
- What happens to filtered-out messages - are they still marked as consumed?
- How would you handle errors in processing certain events?

## Clean Up

Stop Kafka:
```bash
docker compose down
```

## Kafka UI Features to Explore

- **Topics**: View all topics and their configurations
- **Brokers**: See Kafka broker information
- **Consumer Groups**: Monitor consumer lag and offsets
- **Messages**: Browse and search messages

## Architecture

```
Producer (producer.js)
    ↓
Kafka Topic: user-events
    ↓
├── Consumer Group 1 (Load Balanced)
│   ├── Consumer A
│   └── Consumer B
│
└── Consumer Group 2 (Independent)
    ├── Consumer C
    └── Consumer D
```
