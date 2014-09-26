# Follower maze

### Running

To run the app you should have Java and jRuby installed (I'm sure you have) in your system.

```bash
  ./bin/follower-maze-server config1=value config2=value
```

Available config options:

```bash
  logger_level      -> error | debug | info (default)
  logger_output     -> Full path to log file (default: $stdout)
  event_source_port -> 9090 is default
  event_source_host -> '0.0.0.0' is default
  clients_port      -> 9099 is default
  clients_host      -> '0.0.0.0'
```

### Testing

Run RSpec test suite:

```bash
  bundle install
  rspec
```

Run provided .jar test:

```bash
  ./support/followermaze.sh
```

### Design

Idea is simple.

1. Server listens to incoming event stream and creates events.
2. Events are being stored into a sorted set (TreeMap).
3. Once sequence is complete, each event, after applying side effects ("follow", for example), gets expanded to notifications which are then being sent into queue.
4. Dispatcher thread monitors this queue and sends notifications to connected users.

\o/
