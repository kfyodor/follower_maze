lib = File.expand_path './lib'
$:.unshift lib unless $:.include?(lib)

require 'rspec'
require 'follower_maze'