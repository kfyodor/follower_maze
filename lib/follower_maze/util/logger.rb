module FollowerMaze
  module Util
    class Logger
      LEVELS = [:debug, :info, :error]

      attr_writer :logger_level

      def initialize(config = FollowerMaze::Config)
        $stdout.sync = true
        @config = config
      end

      def logger_level
        @logger_level ||= @config.logger_level
      end

      def logger_output
        @logger_output ||= self.logger_output=(@config.logger_output)
      end

      def logger_output=(out)
        @logger_output = File.open(out, "w").tap do |f|
          f.sync = true
        end
      end

      LEVELS.each.with_index do |l, i|
        define_method l do |text|
          if LEVELS.slice(0..i).include? logger_level.to_sym
            logger_output.puts "#{l}: [#{Time.now}] #{text}"
          end
        end
      end
    end
  end
end