module FollowerMaze
  class Event
    attr_reader :type

    def initialize(data)
      @data = data
      parse_data
    end

    def handle!
      case @type
      when "F"
        handle_follow
      when "U"
        handle_unfollow
      when "B"
        handle_broadcast
      when "P"
        handle_private_message
      when "S"
        handle_status_update
      end
    end

    private

    def to_user
      @to_user ||= Base.connections.find(to)
    end

    def from_user
      @from_user ||= Base.connections.find(from)
    end

    def parse_data
      _, @type, @from, @to = @data.split('|')
    end

    def from; @from.to_i; end
    def to;   @to.to_i;   end

    def handle_follow
      if to_user
        to_user.add_follower(from)
        to_user.write(@data)
        puts "Sent Follow to #{to}"
      end
    end

    def handle_broadcast
      Base.connections.each do |c|
        c.write @data
        puts "Sent broadcast to #{c.user_id}"
      end
    end
    
    def handle_unfollow
      if to_user
        to_user.remove_follower(from)
      end
    end
    
    def handle_status_update
      return unless from_user

      Base.connections.find_many(from_user.followers).each do |c|
        c.write @data
        puts "Sent status update to #{c.user_id}"
      end
    end
    
    def handle_private_message
      if to_user
        to_user.write(@data)
        puts "Sent private message to #{to}"
      end
    end
  end
end