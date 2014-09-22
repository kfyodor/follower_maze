module FollowerMaze
  module Util
    class Logger
      LEVELS = [:debug, :info, :error]

      attr_accessor :level, :out

      def initialize(options = {})
        @out   = options[:out]   || $stdout
        @level = options[:level] || :info
      end

      LEVELS.each.with_index do |l, i|
        define_method l do |text|
          if LEVELS.slice(0..i).include? level.to_sym
            @out.puts "#{l}: [#{Time.now}] #{text}"
          end
        end
      end
    end
  end
end