class RdbBoardPermission < ActiveRecord::Base
  belongs_to :rdb_board
  belongs_to :principal, polymorphic: true

  module Roles
    READ = 'read'.freeze
    EDIT = 'edit'.freeze
    ADMIN = 'admin'.freeze
  end
  include Roles

  validates :role,
    inclusion: {in: [READ, EDIT, ADMIN]}
  validates :principal_id,
    presence: true,
    uniqueness: {
      scope: [:rdb_board_id, :principal_type]
    }

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
end
