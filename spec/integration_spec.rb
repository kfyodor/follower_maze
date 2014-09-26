require 'spec_helper'

describe :integration do

  it 'passes the integration test' do
    FollowerMaze.configure do |c|
      c.event_source_port = 3456
      c.clients_port = 4567
      c.logger_output   = File.open("/dev/null", "w")
    end

    base = Thread.new { FollowerMaze::Base.new.run! }

    text =  %x(
      cd #{File.expand_path(File.dirname(__FILE__))}/../support
      export totalEvents=1000
      export concurrencyLevel=10
      export eventListenerPort=3456
      export clientListenerPort=4567

      ./followermaze.sh
    )

    expect(text).to match /\\o\/\sALL\sNOTIFICATIONS\sRECEIVED\s\\o\//m
    base.kill
  end
end