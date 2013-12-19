module Rdb
  module UserPatch
    def self.included(receiver)
      receiver.class_eval do
        unloadable
        has_many :rdb_boards, :as => :context
      end
    end
  end

  User.send :include, Rdb::UserPatch unless User.included_modules.include? Rdb::UserPatch
end
