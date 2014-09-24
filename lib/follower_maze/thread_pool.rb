module FollowerMaze
  class ThreadPool
    # my lame thread pool

    attr_reader :working, :waiting, :threads

    def initialize
      @concurrency = 10 # should be in config
      @mutex = Mutex.new
      @threads = []
      @working = {}
      @cond    = ConditionVariable.new
      @waiting = Queue.new
    end

    def add_work(context, id, &block)
      raise unless block_given?
      @waiting.enq [context, block, id]
    end

    def work
      while @waiting.size > 0
        thread = Thread.new(get_work) do |work|
          context, block, id = work
          mutex              = Mutex.new

          block.call context

          mutex.synchronize do
            @working[id] = nil
            @threads.delete thread
          end
        end
        @threads << thread

        if @working.size == @concurrency
          @threads.map &:join
        end
      end
    end

    def get_work(put_back = nil)
      work  = @waiting.pop
      id    = work[2]
      mutex = Mutex.new

      @waiting.push put_back if put_back

      if @working[id]
        get_work(work)
      else
        mutex.synchronize { @working[id] = true }
        return work
      end
    end
  end
end