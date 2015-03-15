module Rdb
  class Permission < ActiveRecord::Base
    self.table_name = "#{table_name_prefix}rdb_permissions#{table_name_suffix}"
    attr_protected

    belongs_to :dashboard, class_name: 'Rdb::Dashboard'
    belongs_to :principal, polymorphic: true

    module Roles
      READ = 'read'.freeze
      EDIT = 'edit'.freeze
      ADMIN = 'admin'.freeze
    end
    include Roles

    validates :role,
      inclusion: {in: [READ, EDIT, ADMIN], message: 'invalid_role'}

    validates :principal_id,
      presence: {message: 'required'},
      uniqueness: {scope: [:dashboard_id, :principal_type], message: 'already_taken'}

    def read?(principal)
      return false unless [ADMIN, EDIT, READ].include? role
      return false unless principal.active?

      matching_principal? principal
    end

    def write?(principal)
      return false unless [ADMIN, EDIT].include? role
      return false unless principal.active?

      matching_principal? principal
    end

    def admin?(principal)
      return false unless [ADMIN].include? role
      return false unless principal.active?

      matching_principal? principal
    end

    def matching_principal?(principal)
      if self.principal.is_a?(Group)
        self.principal.users.pluck(:id).include? principal.id
      else
        self.principal.id == principal.id
      end
    end

    def as_json(*args)
      {
        id: id,
        role: role.upcase,
        principal: PrincipalDecorator.new(principal).as_json(*args)
      }
    end
  end
end
