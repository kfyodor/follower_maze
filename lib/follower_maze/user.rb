module FollowerMaze
  class User
    attr_reader :id, :followers

    @@users = {}

    class << self
      def all
        @@users.values
      end

      def find(id)
        @@users[id]
      end

      def find_many(ids)
        @@users.select { |k, u| ids.include?(k) }.values
      end

      def create(id, attrs = {})
        new(id, attrs)
      end

      def find_or_create(id)
        @@users.fetch(id) { new(id) }
      end
    end

    def initialize(id, attrs = {})
      @id        = id
      @followers = []
      @connection = attrs[:connection]

      @@users[@id] = self
    end

    def notify(data)
      @connection.write data if @connection
    end

    def add_follower(user_id)
      @followers << user_id
    end

    def remove_follower(user_id)
      @followers.delete(user_id)
    end
  end
end