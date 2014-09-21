require 'set'

module FollowerMaze
  class EventsBuffer
    # It should be fast enough since
    # SortedSet uses red-black tree.
    # proof: https://github.com/ruby/ruby/blob/trunk/lib/set.rb#L579

    attr_reader :max_id, :size, :first_id

    def initialize
      @mutex  = Mutex.new
      @max_id = 0
      reset_state!
    end

    def <<(event)
      puts "New event: from #{event.from}, to #{event.to}, with type #{event.type}"

      @mutex.synchronize do
        @event_ids_buffer << event
        @size += 1
        expand_and_cache_event(event)
        update_max_id! event
      end
      flush if complete_set?
    end

    def min_id
      @event_ids_buffer.first.id
    end

    private

    def expand_and_cache_event(event)
      event.expand.each do |e|
        @atomic_events_buffer[e.to] = (@atomic_events_buffer[e.to] || SortedSet.new) << e
      end
    end

    def update_max_id!(event)
      if event.id > @max_id && size > 1
        @max_id = event.id
      end
    end

    def reset_state!
      @mutex.synchronize do
        @event_ids_buffer     = SortedSet.new
        @atomic_events_buffer = Hash.new
        @size                 = 0
        @first_id             = @max_id + 1
      end
    end

    def complete_set?
      max_id - min_id == size - 1 && min_id == first_id
    end

    def flush
      threads = []

      puts "----> to user_ids: #{@atomic_events_buffer.keys.inspect}"

      @atomic_events_buffer.each do |_, events|
        threads << Thread.new do
          events.each &:handle!
        end
      end
      threads.map &:join 

      puts "----> Sending events with ids #{@event_ids_buffer.map(&:id).inspect}"

      reset_state!

      puts "Cleared buffer."
    end
  end
end