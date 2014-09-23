module Rdb
  class PrincipalDecorator < Decorator
    include ERB::Util
    include GravatarHelper::PublicMethods

    def as_json(*)
      {
        type: type.to_s,
        id: object.id,
        name: object.name,
        avatar_url: avatar_url
      }
    end

    def avatar_url
      if Setting.gravatar_enabled? && type == :user && object.mail.present?
        gravatar_url object.mail,
          size: 128, ssl: true, default: Setting.gravatar_default
      else
        nil
      end
    end

    def type
      case object
        when Group then :group
        when User then :user
        else :unknown
      end
    end
  end
end
