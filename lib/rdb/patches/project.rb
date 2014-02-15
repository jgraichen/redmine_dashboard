module Rdb::Patch
  module Project
    def self.included(receiver)
      receiver.class_eval do
        unloadable
        has_many :rdb_boards, :as => :context
      end
    end

    def rdb_abbreviation
      @rdb_abbreviation ||= begin
        field = custom_field_values.find {|f| f.custom_field.read_attribute(:name).downcase == 'abbreviation' && f.to_s.present?}
        field ? field.to_s : '#'
      end
    end
  end
end

Project.send :include, Rdb::Patch::Project
