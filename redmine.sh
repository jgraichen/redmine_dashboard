#!/bin/bash

if [ -z "$REDMINE_VERSION" ]; then
	VERSION="2.3.2"
else
	VERSION="$REDMINE_VERSION"
fi

BASE=$(pwd)
ARCHIVES="$BASE/tmp/archives"
ARCHIVE="$ARCHIVES/$VERSION.tar.gz"
REDMINE="$BASE/tmp/redmines/$VERSION/"
BUNDLE_PATH="$BASE/tmp/bundle"

redmine()
{
	pushd "$REDMINE" > /dev/null
	$@
	popd > /dev/null
}

download()
{
	mkdir -p "$ARCHIVES"

	if [ ! -f "$ARCHIVE" ] || [ -n "$FORCE" ]; then
			wget -O "$ARCHIVE" "https://github.com/edavis10/redmine/archive/$VERSION.tar.gz"
	fi

	if [ ! -f "$ARCHIVE" ]; then
		echo "Downloaded archive missing. Abort."
		exit 1
	fi

	if [ -f "$ARCHIVE" ] && ([ -n "$FORCE" ] || [ ! -f "$REDMINE/.installed" ]); then
			if [ -d "$REDMINE" ]; then
				rm -rf "$REDMINE"
			fi

			mkdir -p "$REDMINE"
			tar --strip=1 --directory "$REDMINE" -xzf "$ARCHIVE"
	fi
}

install()
{
	set -e

	if [ -f "$REDMINE/.installed" ] && [ -z "$FORCE" ]; then
		exit 0
	fi

	if [ ! -f "$REDMINE/Gemfile" ]; then
		download
	fi

	pushd "$REDMINE" > /dev/null

	if [ -n "$(ruby -v | grep jruby)" ]; then
		DB_ADAPTER="jdbcpostgresql"
	else
		DB_ADAPTER="postgresql"
	fi

	if [ -n "$TRAVIS" ]; then
		$DB_USER="username: postgres"
	fi

	DB_VERSION=${VERSION//\./_}

	cat <<EOF > "$REDMINE/config/database.yml"
common: &common
  pool: 5
  timeout: 5000
  adapter: $DB_ADAPTER
  $DB_USER
test:
  <<: *common
  database: rdb_test_$DB_VERSION<%= ENV['TEST_ENV_NUMBER'] %>
production:
  <<: *common
  database: rdb_$DB_VERSION<%= ENV['TEST_ENV_NUMBER'] %>
development:
  <<: *common
  database: rdb_dev_$DB_VERSION<%= ENV['TEST_ENV_NUMBER'] %>
EOF

	if [ -e "$REDMINE/plugins/redmine_dashboard" ]; then
		rm -f "$REDMINE/plugins/redmine_dashboard"
	fi
	if [ -e "$REDMINE/spec" ]; then
		rm -f "$REDMINE/spec"
	fi

	ln -s "$BASE" "$REDMINE/plugins/redmine_dashboard"
	ln -s "$BASE/spec" "$REDMINE/spec"

	mkdir -p "$REDMINE/public/plugin_assets"
	if [ -e "$REDMINE/public/plugin_assets/redmine_dashboard_linked" ]; then
		rm -f "$REDMINE/public/plugin_assets/redmine_dashboard_linked"
	fi
	ln -s "$BASE/assets" "$REDMINE/public/plugin_assets/redmine_dashboard_linked"

	_bundle_install

	redmine bundle exec rake generate_secret_token

	_update_redmine

	redmine bundle exec rake redmine:load_default_data REDMINE_LANG=en

	touch "$REDMINE/.installed"

	popd > /dev/null

	set +e
}

_bundle_install()
{
	if [ ! -d "$REDMINE" ]; then
		echo "First install redmine. Abort."
		exit 1
	fi

	sed -i -e "s/.*gem [\"']capybara[\"'].*//g" "$REDMINE/Gemfile"
	redmine bundle install --path "$BUNDLE_PATH" --without rmagick
	redmine bundle --binstubs
}

update()
{
	if [ ! -d "$REDMINE" ]; then
		echo "First install redmine. Abort."
		exit 1
	fi

	sed -i -e "s/.*gem [\"']capybara[\"'].*//g" "$REDMINE/Gemfile"
	redmine bundle update
	redmine bundle --binstubs
}

_update_redmine()
{
	redmine bundle exec rake db:create:all
	redmine bundle exec rake db:migrate
	redmine bundle exec rake db:migrate RAILS_ENV=test
	redmine bundle exec rake redmine:plugins:migrate
	redmine bundle exec rake redmine:plugins:migrate RAILS_ENV=test
}

server()
{
	redmine_bundle exec rails server $@
}

remove()
{
	rm -rf "$REDMINE"
}

spec()
{
	if [ ! -d "$REDMINE" ]; then
		echo "First install redmine. Abort."
		exit 1
	fi

	echo ">>>>" --color --tty $@
	redmine ./bin/rspec --color --tty $@
	echo $?
	echo "<<<<" --color --tty $@
}

ci()
{
	if [ ! -d "$REDMINE" ]; then
		echo "First install redmine. Abort."
		exit 1
	fi

	redmine ./bin/rspec --color --tty spec
}

# set -x

case "$1" in
	install)
		shift 1
		install $@
	;;
	download)
		shift 1
		download $@
	;;
	update)
		shift 1
		update $@
	;;
	server)
		shift 1
		server $@
	;;
	remove)
		shift 1
		remove $@
	;;
	spec)
		shift 1
		spec $@
	;;
	ci)
		shift 1
		ci $@
	;;
esac
