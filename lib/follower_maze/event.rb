module FollowerMaze
  class Event
    attr_reader :id, :type, :from, :to, :payload

    def initialize(payload)
      @payload = payload
      @id, @type, @from, @to = @payload.split("|")
    end
  end
end