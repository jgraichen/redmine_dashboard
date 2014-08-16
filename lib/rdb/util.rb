module Rdb::Util
  class << self
    def none(scope)
      scope.where('FALSE')
    end
  end
end
