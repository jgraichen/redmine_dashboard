module Rdb::Patch
  module Issue

    def rdb_id
      @rdb_id ||= begin
        title = "#{project.rdb_abbreviation}-" if project.rdb_abbreviation
        "#{title}#{id}"
      end
    end
  end
end

Issue.send :include, Rdb::Patch::Issue
