lib = File.expand_path './lib'
$:.unshift lib unless $:.include?(lib)

require 'rspec'
require 'follower_maze'

class EventSource
  # we don't care about unfollows after follows etc., it's a test

  PAYLOAD_DELIMITER = "|"

  def initialize(options = {})
    @tick            = 0
    @last_tick       = false
    @event_types     = %w(B S F U P)
    @user_ids        = (1..(options[:num_users] || 100)).to_a
    @connected_users = @user_ids.sample(options[:connected_users_num] || 10 )
    @chunk_size      = options[:chunk_size] || 30
    @events_num      = options[:events_num] || 300

    rebuild_sequence!    
  end

  def next
    id      = @sequence.next
    to      = random_user
    from    = random_user
    type    = random_type
    payload = pack_payload(id, type, from, to)
    
    FollowerMaze::Event.from_payload(payload)
  rescue StopIteration
    @tick += 1
    @last_tick ? raise(StopIteration) : rebuild_sequence!
  end

  private

  def pack_payload(id, type, from, to)
    case type
    when "F", "U", "P"
      [id, type, from, to]
    when "S"
      [id, type, from]
    when "B"
      [id, type]
    end.join PAYLOAD_DELIMITER
  end

  def rebuild_sequence!
    start  = @tick * @chunk_size + 1
    finish = ((@tick + 1) * @chunk_size).tap do |f|
      if f >= @events_num
        f = @events_num
        @last_tick = true
      end
    end
    @sequence = (start..finish).to_a.shuffle.map
  end

  def random_user
    @user_ids.sample
  end

  def random_type
    @event_types.sample
  end
end