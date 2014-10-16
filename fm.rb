## naive – client timeouts on broadcasts, more memory consuming
##       - faster on low amount of events

require 'thread'
require 'socket'

Thread.abort_on_exception = true

class User
  attr_reader :followers, :id, :connection

  def initialize(id, conn = nil)
    @id = id
    @followers = []
    @connection = conn
  end

  def add_follower(u)
    @followers << u
  end

  def remove_follower(u)
    @followers.delete(u)
  end
end

$mutex = Mutex.new
$users = {}
$events_buffer = {}
$queue = Queue.new

$next_event_id = 1

event_listener = Thread.new do
  server = TCPServer.new('0.0.0.0', 9090).tap do |s|
    s.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
  end

  loop do
    conn = server.accept

    until conn.eof?
      parse_event conn.readline.strip
    end
  end
end

client_listener = Thread.new do
  server = TCPServer.new('0.0.0.0', 9099).tap do |s|
    s.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
  end

  loop do
    conn = server.accept

    id = conn.readline.strip

    $users[id.to_i] = User.new(id, conn)
  end
end

event_sender = Thread.new do
  loop do
    type, from, to, payload = $queue.pop

    case type
    when "P"
      send_to_user(to, payload)
    when "F"
      user(to).followers << from
      send_to_user(to, payload)
    when "U"
      user(to).followers.delete from
    when "S"
      user(from).followers.each do |id|
        send_to_user(id, payload)
      end
    when "B"
      $users.values.each do |user|
        send_to_user(user.id, payload)
      end
    end
  end
end

sequence_watcher = Thread.new do
  loop do    
    $mutex.synchronize do
      if $events_buffer.has_key?($next_event_id)
        $queue << $events_buffer.delete($next_event_id)
        $next_event_id += 1
      end
    end
  end
end

def user(id)
  unless $users.has_key?(id.to_i)
    $users[id.to_i] = User.new(id)
  end

  $users[id.to_i]
end

def send_to_user(id, payload)  
  if conn = user(id.to_i).connection
    conn.puts payload
  end
end

def parse_event(data)
  id, type, from, to = data.split('|')  

  $mutex.synchronize do
    $events_buffer[id.to_i] = [type, from, to, data]
  end
end

trap(:INT) do
  [
    event_listener,
    client_listener,
    event_sender,
    sequence_watcher
  ].map(&:kill)

  puts "Quit."
end

[event_listener, client_listener].map(&:join)