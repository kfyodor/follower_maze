# coding: utf-8
lib = File.dirname(__FILE__)
$:.unshift lib unless $:.include?(lib)

require 'thread'
require 'socket'

require 'follower_maze/util/listener'
require 'follower_maze/event_source_listener'
require 'follower_maze/clients_listener'
require 'follower_maze/user_connection_pool'
require 'follower_maze/user_connection'
require 'follower_maze/base'
require 'follower_maze/atomic_event'
require 'follower_maze/event'
require 'follower_maze/events_buffer'

module FollowerMaze
  EVENT_SOURCE_PORT = 9090
  CLIENTS_PORT      = 9099
  DELIMITER         = $/

  Thread.abort_on_exception = true
end