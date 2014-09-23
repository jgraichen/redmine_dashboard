module Rdb
  class Dashboard < ActiveRecord::Base
    self.table_name = "#{table_name_prefix}rdb_dashboards#{table_name_suffix}"

    serialize :preferences
    has_many :sources, class_name: 'Rdb::Source'
    has_many :permissions, class_name: 'Rdb::Permission'

    validates :name,
      uniqueness: {message: 'already_taken'},
      presence: {message: 'required'}

    after_initialize do
      unless preferences.is_a?(Hash)
        self.preferences = {}
      end
    end

    def issues
      if sources.any?
        sources.first.issues
      else
        Issue.where('FALSE')
      end
    end

    def categories
      if sources.any?
        sources.first.categories
      else
        Category.where('FALSE')
      end
    end

    def trackers
      if sources.any?
        sources.first.trackers
      else
        Tracker.where('FALSE')
      end
    end

    def readable_for?(principal)
      if principal.respond_to?(:admin?) && principal.admin?
        true
      else
        permissions.any?{|permission| permission.read?(principal) }
      end
    end

    def writable_for?(principal)
      if principal.respond_to?(:admin?) && principal.admin?
        true
      else
        permissions.any?{|permission| permission.write?(principal) }
      end
    end

    def administrable_for?(principal)
      if principal.respond_to?(:admin?) && principal.admin?
        true
      else
        permissions.any?{|permission| permission.admin?(principal) }
      end
    end

    def update_board!(params)
      update_attributes! name: params.fetch(:name) if params.key?(:name)
    end

    def type_name
      self.class.name.split('::').last.downcase
    end

    def as_json(*)
      {
        id: id,
        name: name,
        type: type_name,
        permissions: permissions
      }
    end
  end
end
