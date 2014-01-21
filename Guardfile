# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'shell' do
  watch(%r{^app/assets/.*}) do
    `bundle exec rake assets:compile`
  end
end
