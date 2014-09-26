module FollowerMaze
  class Config
    module Helper
      def config_item(key, default_value)
        attr_writer key

        define_method(key) do
          instance_variable_get("@#{key}") || default_value
        end
      end
    end

    class << self
      extend Helper

      config_item :logger_level,      :info
      config_item :logger_output,     $stdout
      config_item :event_source_port, 9090
      config_item :event_source_host, '0.0.0.0'
      config_item :clients_port,      9099
      config_item :clients_host,      '0.0.0.0'
    end
  end
end