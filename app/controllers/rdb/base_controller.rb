module Rdb
  class BaseController < ::ApplicationController
    def check_read_permission
      unauthorized! unless board.readable_for? User.current
    end

    def check_write_permission
      unauthorized! unless board.writable_for? User.current
    end

    def check_admin_permission
      unauthorized! unless board.administrable_for? User.current
    end

    def unauthorized!
      render_404 # Do not leak if a board exists
    end
  end
end
