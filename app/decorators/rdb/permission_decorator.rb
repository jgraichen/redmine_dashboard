module Rdb
  class PermissionDecorator < Draper::Decorator
    def as_json(*args)
      {
        id: object.id,
        principal: principal.as_json(*args),
        role: object.role.upcase
      }
    end

    def principal
      Rdb::PrincipalDecorator.decorate object.principal
    end
  end
end
