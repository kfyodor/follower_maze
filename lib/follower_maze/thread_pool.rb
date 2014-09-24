module FollowerMaze
  class ThreadPool
    # my lame thread pool

    attr_reader :working, :waiting, :threads

    def initialize
      @concurrency = 25 # should be in config
      @mutex = Mutex.new
      @working = {}
      @cond    = ConditionVariable.new
      @waiting = Queue.new

      @recursion_count = 0
    end

    def add_work(context, id, &block)
      raise unless block_given?
      @waiting.enq [context, block, id]
    end

    def work
      while @waiting.size > 0
        thread = Thread.new do |t|
          context, block, id = get_work_for(thread)
          block.call context

          @mutex.synchronize do
            @working.delete id
          end
        end

        @mutex.synchronize do
          if @working.size == @concurrency
            @working.values.map &:join
          end
        end
      end
    end

    # do we need this?
    def get_work_for(thread, put_back = nil)
      work  = @waiting.pop
      id    = work[2]

      @waiting.push put_back if put_back

      if @working[id]
        get_work_for(thread, work)
      else
        @mutex.synchronize { @working[id] = thread }
        return work
      end
    end
  end
end