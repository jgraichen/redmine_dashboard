class RdbBoardPermission < ActiveRecord::Base
  belongs_to :rdb_board
  belongs_to :principal, polymorphic: true

  ADMIN = 'admin'.freeze
  READ = 'read'.freeze

  def read?(principal)
    return false unless [ADMIN, READ].include? role
    return false unless principal.active?

    matching_principal? principal
  end

  def write?(principal)
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
