# Redmine Dashboard 3

[![Build Status](http://img.shields.io/travis/jgraichen/redmine_dashboard.svg?style=flat)](https://travis-ci.org/jgraichen/redmine_dashboard)
[![Code Climate](http://img.shields.io/codeclimate/github/jgraichen/redmine_dashboard.svg?style=flat)](https://codeclimate.com/github/jgraichen/redmine_dashboard)
[![Rate at redmine.org](http://img.shields.io/badge/rate%20at-redmine.org-blue.svg?style=flat)](http://www.redmine.org/plugins/redmine-dashboard)
[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=jgraichen&url=https://github.com/jgraichen/redmine_dashboard&tags=github&category=software)

***NOTE***: This README is for the **current development version** of Redmine Dashboard 3. <br /> ***[Click here for current stable Redmine Dashboard 2.](https://github.com/jgraichen/redmine_dashboard/tree/stable-v2#readme)***

Redmine Dashboard 3 is a full rewrite of the [stable Redmine Dashboard 2](https://github.com/jgraichen/redmine_dashboard/tree/stable-v2). Redmine Dashboard 3 is pre-alpha. As of now you cannot even drag issues.

## Install v3 pre-alpha

As Redmine Dashboard 3 is still pre-alpha it can only build from source. You need Ruby, NodeJS with NPM, bower and make.

Clone repository and install NPM and bower dependencies:

	$ git clone git@github.com:jgraichen/redmine_dashboard.git -b master
	$ make install-deps

Compile development or production (minified) client-side components:

	$ make css js # development
	$ make min # production

Install redmine plugin like any redmine plugin

	$ bundler install
	$ rake redmine:plugins:migrate

## Contributing

### Translate

You can help even without coding by translating Redmine Dashboard or improving an existing localization. I prefer translations via [Transifex](https://www.transifex.com/organization/redmine_dashboard/dashboard/redmine-dashboard) but also gladly accept Pull Requests for the YAML files.

[![Translation status](https://www.transifex.com/projects/p/redmine-dashboard/resource/strings/chart/image_png)](https://www.transifex.com/projects/p/redmine-dashboard/)

### Features

You can also add a new or requested feature by sending a Pull Request. Please add specs so that I do not break your feature in the future.

There are several rake and make tasks to setup a working development environment and run all specs. See [CONTRIBUTING.md](CONTRIBUTING.md) of more information.

## License

```
Copyright (C) 2013-2014 Jan Graichen <jg@altimos.de>

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
