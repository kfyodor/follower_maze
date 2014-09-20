require 'thread'
require 'socket'


require_relative 'follower_maze/event_source_listener'
require_relative 'follower_maze/clients_listener'
require_relative 'follower_maze/user_connection_pool'
require_relative 'follower_maze/user_connection'
require_relative 'follower_maze/base'
require_relative 'follower_maze/event'

module FollowerMaze
  EVENT_SOURCE_PORT = 9090
  CLIENTS_PORT      = 9099
  DELIMITER         = $/
  CONCURRENCY_LEVEL = 8

  Thread.abort_on_exception = true
end