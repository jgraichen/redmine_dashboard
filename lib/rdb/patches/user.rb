module Rdb::Patch
  module User
    def self.included(receiver)
      receiver.class_eval do
        unloadable
        has_many :rdb_boards, :as => :context
      end
    end
  end
end

User.send :include, Rdb::Patch::User
