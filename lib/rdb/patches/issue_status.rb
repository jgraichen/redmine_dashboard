module Rdb::Patch
  module IssueStatus
    def self.included(base)
      base.class_eval do
        scope :rdb_open, -> { where is_closed: false }
        scope :rdb_closed, -> { where is_closed: true }
      end
    end
  end
end

IssueStatus.send :include, Rdb::Patch::IssueStatus
