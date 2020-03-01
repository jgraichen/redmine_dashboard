source 'https://rubygems.org'
# Gems required by redmine_dashboard

send :ruby, RUBY_VERSION if ENV['CI']

gem 'slim', require: false

def gem(name, *args, **opts)
  if (existing_dep = @dependencies.find {|d| d.name == name })
    args += existing_dep.requirement.as_list
    @dependencies.delete existing_dep
  end

  super(name, *args, **opts)
end

group :development, :test do
  gem 'rspec', '~> 3.0', require: false
  gem 'rspec-rails', require: false
  gem 'database_cleaner', require: false

  # for redmine on travis CI
  gem 'test-unit'
  gem 'selenium-webdriver'
end

group :development do
  gem 'pry'
  gem 'pry-nav'
end
