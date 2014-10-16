module FollowerMaze
  class User
    class Repository
      def initialize
        @users = {}
      end

      def <<(user)
        @users[user.id.to_i] = user
      end

      def all
        @users.values
      end

      def find_many(ids)
        @users.select { |k, u| ids.include?(k) }.values
      end

      def find(id)
        @users.fetch(id.to_i) { User.new(id) }
      end
    end
  end
end