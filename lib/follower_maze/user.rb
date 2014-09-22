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
        @@users.values.select { |u| ids.include? u.id }
      end

      def create(id, attrs = {})
        new(id, attrs)
      end

      def find_or_create(id)
        @@users.fetch(id) do
          $mutex.synchronize { new(id) }
        end
      end
    end

    def initialize(id, attrs = {})
      @id = id
      @followers = []
      @mutex = Mutex.new
      @mutex.synchronize { @@users[@id] = self }
    end

    def notify(data)
      connection = Base.connections.find_by_user_id(id)

      if connection
        connection.write data
      end
    end

    def add_follower(user_id)
      @mutex.synchronize do
        @followers << user_id
      end
    end

    def remove_follower(user_id)
      @mutex.synchronize do
        @followers.delete(user_id)
      end
    end
  end
end