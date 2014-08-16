ActionDispatch::Routing::Mapper::HttpHelpers.module_eval do
  # Define a route that only recognizes HTTP PATCH.
  # For supported arguments, see <tt>Base#match</tt>.
  #
  # Example:
  #
  # patch 'bacon', :to => 'food#bacon'
  def patch(*args, &block)
    map_method(:patch, *args, &block)
  end

  def put(*args, &block)
    map_method(:put, *args, &block)
    map_method(:patch, *args, &block)
  end
end

ActiveSupport.on_load(:action_controller) do
  ActionDispatch::Request.module_eval do
    # Is this a PATCH request?
    # Equivalent to <tt>request.request_method == :patch</tt>.
    def patch?
      HTTP_METHOD_LOOKUP[request_method] == :patch
    end
  end

  module ActionDispatch::Routing
    HTTP_METHODS << :patch unless HTTP_METHODS.include?(:patch)
  end

  ActionDispatch::Integration::RequestHelpers.module_eval do
    # Performs a PATCH request with the given parameters. See +#get+ for more
    # details.
    def patch(path, parameters = nil, headers = nil)
      process :patch, path, parameters, headers
    end

    # Performs a PATCH request, following any subsequent redirect.
    # See +request_via_redirect+ for more information.
    def patch_via_redirect(path, parameters = nil, headers = nil)
      request_via_redirect(:patch, path, parameters, headers)
    end
  end

  ActionDispatch::Integration::Runner.class_eval do
    %w(patch).each do |method|
      define_method(method) do |*args|
        reset! unless integration_session
        # reset the html_document variable, but only for new get/post calls
        @html_document = nil unless method.in?(["cookies", "assigns"])
        integration_session.__send__(method, *args).tap do
          copy_session_variables!
        end
      end
    end
  end

  module ActionController::TestCase::Behavior
    def patch(action, parameters = nil, session = nil, flash = nil)
      process(action, parameters, session, flash, "PATCH")
    end
  end

  class ActionController::Responder
    ACTIONS_FOR_VERBS.update(:patch => :edit)
    delegate :patch?, :to => :request
  end

  module ActionDispatch::Routing::Mapper::Resources
    class SingletonResource
      def resource(*resources, &block)
        options = resources.extract_options!.dup

        if apply_common_behavior_for(:resource, resources, options, &block)
          return self
        end

        resource_scope(:resource, SingletonResource.new(resources.pop, options)) do
          yield if block_given?

          collection do
            post :create
          end if parent_resource.actions.include?(:create)

          new do
            get :new
          end if parent_resource.actions.include?(:new)

          member do
            get    :edit if parent_resource.actions.include?(:edit)
            get    :show if parent_resource.actions.include?(:show)
            if parent_resource.actions.include?(:update)
               # all that for this PATCH
               patch  :update
               put    :update
            end
            delete :destroy if parent_resource.actions.include?(:destroy)
          end
        end

        self
      end
    end
  end
end
