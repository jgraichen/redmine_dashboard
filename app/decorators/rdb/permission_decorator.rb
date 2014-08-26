module Rdb
  class PermissionDecorator < Draper::Decorator
    delegate_all

    def as_json(*)
      {
        id: id,
        principal: {
          type: type.to_s,
          id: principal.id,
          name: principal.name,
          avatar_url: avatar_url
        },
        role: role.upcase
      }
    end

    def avatar_url
      if Setting.gravatar_enabled? && type == :user
        h.gravatar_url principal.mail,
          size: 128, ssl: true, default: Setting.gravatar_default
      else
        nil
      end
    end

    def type
      case principal
        when Group then :group
        when User then :user
        else :unknown
      end
    end
  end
end
