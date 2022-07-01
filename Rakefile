# frozen_string_literal: true

require 'pathname'
require 'yaml'

require 'rspec/core/rake_task'

task default: [:spec]

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern    = ENV.fetch('SPEC', 'spec/**/*_spec.rb')
  t.ruby_opts  = '-Ispec'
  t.rspec_opts = '--color --backtrace'
  t.rspec_opts << " --seed #{ENV['SEED']}" if ENV['SEED']
end

namespace :i18n do
  desc 'Fix locale files after tx pull'
  task :fix do
    Pathname.glob('config/locales/*.yml').each do |file|
      data = YAML.safe_load(file.read)

      # Transifex exports data inside the YAML using underscored
      # identifiers (e.g. pt_BR), but Redmine needs dashed identifiers
      # (pt-bR). We need convert each top-level key to use dashes.
      #
      # rubocop: We cannot modify a hash when iterating using
      # `#each_key`. Therefore, we must us `keys.each` here.
      data.keys.each do |key| # rubocop:disable Style/HashEachMethods
        if key.include?('_')
          data[key.gsub('_', '-')] = data.delete(key)
        end
      end

      fix_pluralizations = lambda do |locale_data|
        # Redmine does not contain pluralization rules, but many
        # languages only need an `other` key according to Unicode. Tools
        # like transifex expect proper pluralization rules and do not
        # export a `one` key when only an `other` key is needed, such as
        # for Japanese.
        #
        # This method searches the locale data for any nested dicitonary
        # that looks like a pluralized section (contains only `one`,
        # `few`, `other` `many`, `zero` keys). If found, an `one` key
        # will be added with the `other` value.
        locale_data.each_value do |value|
          next unless value.is_a?(Hash)

          if (value.keys - %w[one few other many zero]).empty?
            value['one'] ||= value['other'] if value.key?('other')
          else
            fix_pluralizations.call(value)
          end
        end
      end

      fix_pluralizations.call(data)

      file.write(YAML.dump(data, line_width: -1))
    end
  end
end
