module FollowerMaze
  class ThreadPool
    # my lame thread pool
    def initialize
      @concurrency = 25 # should be in config
      @mutex = Mutex.new
      @threads = []
      @working = []
      # @cond    = ConditionVariable.new
      @waiting = Queue.new
    end

    def add_work(context, options = {}, &block)
      raise unless block_given?
      @waiting.enq [context, block, options]
    end

    def work
      while @waiting.size > 0
        @threads << Thread.new(@waiting.pop) do |w|
          context, block, options = w
          block.call context
        end

        if @threads.size == @concurrency
          @threads.each &:join
          @threads = []
        end
      end
    end
  end
end