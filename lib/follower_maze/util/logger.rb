require 'stringio'

module FollowerMaze
  module Util
    class Logger
      LEVELS = [:debug, :info, :error]

      attr_writer :logger_level
      attr_reader :logger_output

      def initialize(config = FollowerMaze::Config)
        $stdout.sync = true
        @config = config
      end

      def logger_level
        @logger_level ||= @config.logger_level
      end

      def logger_output
        @logger_output ||= set_output
      end

      def logger_output=(out)
        set_output(out)
      end

      LEVELS.each.with_index do |l, i|
        define_method l do |text|
          if LEVELS.slice(0..i).include? logger_level.to_sym
            logger_output.puts "#{l}: [#{Time.now}] #{text}"
          end
        end
      end

      private

      def set_output(out = nil)
        out ||= @config.logger_output

        @logger_output = 
          if out.respond_to?(:puts)
            out
          elsif out.kind_of
            File.open(out, "w").tap { |f| f.sync = true }
          end
      end
    end
  end
end