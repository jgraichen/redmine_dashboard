module Rdb
  module ProjectPatch
    def self.included(receiver)
      receiver.class_eval do
        unloadable
        has_many :rdb_boards, :as => :context
      end
    end
  end

  Project.send :include, Rdb::ProjectPatch unless Project.included_modules.include? Rdb::ProjectPatch
end
