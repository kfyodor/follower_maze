require 'rubygems'
require 'bundler/setup'

desc 'Default: run specs'
task :default => :spec  

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t|
  t.pattern = File.expand_path File.dirname(__FILE__), "spec/**/*_spec.rb"
end