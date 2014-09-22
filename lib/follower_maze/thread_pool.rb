module FollowerMaze
  class ThreadPool
    # my lame thread pool
    def initialize
      @concurrency = 40
      @mutex = Mutex.new
      @threads = []
      @waiting = Queue.new

      work
    end

    def add_work context, &block
      raise unless block_given?
      @waiting.push [context, block]
    end

    def work
      while @waiting.size > 0
        context, block = @waiting.pop
        @threads << Thread.new(context, &block)

        if @threads.size == @concurrency
          @threads.each &:join
          @threads = []
        end
      end

      @threads.each &:join
    end
  end
end