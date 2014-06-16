module Rdb
  module Assets
    def self.env
      @env ||= begin
        require 'sprockets'

        # Skim::Engine.default_options[:use_asset] = true

        Sprockets::Environment.new Dir.pwd do |env|
          %w(app/assets/images
             app/assets/stylesheets
             app/assets/javascripts
             vendor/assets/javascripts
             vendor/assets/stylesheets).each do |source|
            path = File.expand_path(File.join('../../..', source), __FILE__)
            env.append_path path
          end
        end
      end
    end
  end
end
