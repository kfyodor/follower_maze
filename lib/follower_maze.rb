# coding: utf-8

lib = File.dirname(__FILE__)
$:.unshift lib unless $:.include?(lib)

require 'thread'
require 'socket'

require 'follower_maze/util/listener'
require 'follower_maze/util/sequence_checker'
require 'follower_maze/util/logger'
require 'follower_maze/thread_pool'
require 'follower_maze/event_source_listener'
require 'follower_maze/clients_listener'
require 'follower_maze/client_connections_pool'
require 'follower_maze/client_connection'
require 'follower_maze/user'
require 'follower_maze/base'
require 'follower_maze/notification'
require 'follower_maze/event'
require 'follower_maze/dispatcher'

module FollowerMaze
  EVENT_SOURCE_PORT = 9090
  CLIENTS_PORT      = 9099
  DELIMITER         = $/

  Thread.abort_on_exception = true
  $mutex = Mutex.new
end