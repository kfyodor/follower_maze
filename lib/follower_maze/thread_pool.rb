module FollowerMaze
  class ThreadPool
    attr_reader :working, :waiting

    def initialize
      @concurrency = 1
      @mutex   = Mutex.new
      @working = {}
      @waiting = Queue.new
    end

    def run
      @concurrency.times { spawn_thread }
    end

    def spawn_thread
      Thread.new do
        loop do
          context, block, id = get_work

          @mutex.synchronize do
            @working[id] = true
          end

          block.call context

          @mutex.synchronize do
            @working.delete id
          end
        end
      end
    end

    def add_work(context, id, &block)
      raise unless block_given?
      @waiting.enq [context, block, id]
    end
    alias << add_work

    # do we need this?
    def get_work(put_back = nil)
      work  = @waiting.pop
      id    = work[2]

      @waiting.push put_back if put_back

      if @working[id]
        get_work(work)
      else
        return work
      end
    end
  end
end