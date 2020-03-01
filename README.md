# Redmine Dashboard

[![GitHub Workflow Status](https://github.com/jgraichen/redmine_dashboard/workflows/Test/badge.svg?branch=master)](https://github.com/jgraichen/redmine_dashboard/actions?query=branch%3Amaster)
[![Rate at redmine.org](http://img.shields.io/badge/rate%20at-redmine.org-blue.svg?style=for-the-badge)](http://www.redmine.org/plugins/redmine-dashboard)
[![Follow at Twitter](http://img.shields.io/badge/follow%20at-twitter-blue.svg?style=for-the-badge)](https://twitter.com/RmDashboard)

***NOTE***: This README is for the **development version** of Redmine Dashboard 3.

## ***[Click here for current stable Redmine Dashboard 2](https://github.com/jgraichen/redmine_dashboard/tree/stable-v2#readme)***

[![Redmine Dashboard v2.x Screenshot](http://altimos.de/rdb/img/rdb_2-1.png)](https://github.com/jgraichen/redmine_dashboard/tree/stable-v2#readme)

Redmine Dashboard 3 is a full rewrite of the [stable Redmine Dashboard 2](https://github.com/jgraichen/redmine_dashboard/tree/stable-v2). Redmine Dashboard 3 is pre-alpha. As of now you cannot even drag issues.

## Install v3 pre-alpha

As Redmine Dashboard 3 is still pre-alpha it can only build from source. You need Ruby, NodeJS with NPM, bower and make.

Clone repository and install NPM dependencies:

	$ git clone git@github.com:jgraichen/redmine_dashboard.git -b master
	$ bundle install
	$ npm install

Compile development or production (minified) client-side components:

	$ make css js # development
	$ make min # production

The default target compiles for development.

Install plugin like any Redmine plugin and run:

	$ bundle install
	$ rake redmine:plugins:migrate

<!--
## Contributing

### Translate

You can help even without coding by translating Redmine Dashboard or improving an existing localization. I prefer translations via [Transifex](https://www.transifex.com/organization/redmine_dashboard/dashboard/redmine-dashboard) but also gladly accept Pull Requests for the YAML files.

[![Translation status](https://www.transifex.com/projects/p/redmine-dashboard/resource/strings/chart/image_png)](https://www.transifex.com/projects/p/redmine-dashboard/)

### Features

You can also add a new or requested feature by sending a Pull Request. Please add specs so that I do not break your feature in the future.

There are several rake and make tasks to setup a working development environment and run all specs. See [CONTRIBUTING.md](CONTRIBUTING.md) of more information.
-->

## License

```
Copyright (C) 2011-2015 Jan Graichen <jg@altimos.de>

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
details.

All contributions will be included under the terms of the GNU Affero General
Public License as published by the Free Software Foundation, either version 3
of the License, or (at your option) any later version.
```
