require 'i18n'
require 'i18n/exceptions'

module ActionView
  module Helpers
    module TranslationHelper
      alias_method :orig_translate, :translate
      def translate(key, options = {})
        options.merge!(:rescue_format => :html) unless options.key?(:rescue_format)
        options[:default] = wrap_translate_defaults(options[:default]) if options[:default]

        html_safe_options = options.dup
        options.except(*I18n::RESERVED_KEYS).each do |name, value|
          unless name == :count && value.is_a?(Numeric)
            html_safe_options[name] = ERB::Util.html_escape(value.to_s)
          end
        end

        unless html_safe_options[:brand] || key == :brand
          html_safe_options[:brand] = (@brand ||= translate(:brand))
        end

        translation = I18n.translate!(scope_key_by_partial(key), html_safe_options)
        translation.respond_to?(:html_safe) ? translation.html_safe : translation
      rescue I18n::MissingTranslationData => e
        raise e if options[:raise]

        missing_key = I18n.normalize_keys(e.locale, e.key, nil).join('.')

        Rails.logger.warn "* Translation missing: #{missing_key}"

        if Rails.env.production? && e.locale != 'en'
          translate(key, options.merge(locale: :en))
        else
          "[[#{missing_key}]]"
        end
      end
      alias :t :translate
    end
  end
end
