module FollowerMaze
  class User
    class Repository
      def initialize
        @users = {}
      end

      def <<(user)
        @users[user.id] = user
      end

      def all
        @users.values
      end

      def find(id)
        @users[id] ||= User.new(id)
      end
    end
  end
end