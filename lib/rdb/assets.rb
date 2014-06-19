module Rdb
  module Assets
    def self.setup(env)
      %w(app/assets/images
         app/assets/stylesheets
         app/assets/javascripts
         vendor/assets/javascripts
         vendor/assets/stylesheets).each do |source|
        path = File.expand_path(File.join('../../..', source), __FILE__)
        env.append_path path
      end

      env.logger.level = Logger::DEBUG
    end
  end
end
