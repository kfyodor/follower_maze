module FollowerMaze
  class ThreadPool
    # my lame thread pool

    attr_reader :working, :waiting, :threads

    def initialize
      @concurrency = 25 # should be in config
      @mutex = Mutex.new
      @threads = []
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
        thread = Thread.new do
          context, block, id = get_work

          block.call context

          @mutex.synchronize do
            @working.delete id
            @threads.delete thread
          end
        end

        @mutex.synchronize do
          @threads << thread
        end

        if @working.size == @concurrency
          @threads.map &:join
        end
      end
    end

    def get_work(put_back = nil)
      work  = @waiting.pop
      id    = work[2]

      @waiting.push put_back if put_back

      if @working[id]
        get_work(work)
      else
        @mutex.synchronize { @working[id] = true }
        return work
      end
    end
  end
end