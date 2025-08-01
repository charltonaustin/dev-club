# example_collaboration_testing

This is an example n layer app with three layers.
The first layer is the controller layer.
The second layer is the service layer.
The third layer is the database layer.

The model is meant to approximate the [active record pattern](https://en.wikipedia.org/wiki/Active_record_pattern).

## Setup

```shell
bundle
bundle exec ruby db/create_db.ruby
```

## Run

```shell
bundle exec ruby controllers/task.rb
```

## Use

### Create a task

```shell
curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"name": "this", "done": false}' \
  http://127.0.0.1:4567/tasks
```

### See all tasks

```shell
curl http://127.0.0.1:4567/tasks | jq
```

### See completed tasks

```shell
curl http://127.0.0.1:4567/tasks/completed | jq
```

### See incomplete tasks

```shell
curl http://127.0.0.1:4567/tasks/incomplete | jq
```

### Cause a failure

```shell
curl http://127.0.0.1:4567/should_fail
```

## Test

```shell
bundle exec rspec
```
