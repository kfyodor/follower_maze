require 'set'

module FollowerMaze
  class EventsBuffer
    # It should be pretty fast
    # since SortedSet uses red-black tree.
    # https://github.com/ruby/ruby/blob/trunk/lib/set.rb#L579

    attr_reader :max_id, :size, :first_id

    def initialize
      @mutex        = Mutex.new
      @buffer       = SortedSet.new
      @events_cache = Hash.new
      @size         = 0
      @max_id       = 0
      @first_id     = 1
    end

    def <<(event)
      @mutex.synchronize do
        @buffer << event.id
        cache_event! event
        @size += 1
        update_max_id! event
      end
      flush if complete_set?
    end

    def min_id
      @buffer.first
    end

    private

    def cache_event!(event)
      key = event.to || 0
      @events_cache[key] = (@events_cache[key] || SortedSet.new) << event
    end

    def update_max_id!(event)
      if event.id > @max_id && size > 1
        @max_id = event.id
      end
    end

    def clear_buffer!
      @mutex.synchronize do
        @buffer       = SortedSet.new
        @events_cache = {}
        @first_id = @max_id + 1
        @size     = 0
      end
      puts '----> Cleared buffer'
    end

    def complete_set?
      max_id - min_id == size - 1 && min_id == first_id
    end

    def flush
      threads = []
      @events_cache.each do |k, v| 
        threads << Thread.new(v) do |events|
          events.each &:handle!
        end
      end
      threads.map &:join 

      puts "----> Sending events with ids #{@buffer.inspect}"
      clear_buffer!
    end
  end
end