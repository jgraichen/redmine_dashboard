# Redmine Dashboard 2

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/jgraichen/redmine_dashboard/Test?label=CI&style=for-the-badge)](https://github.com/jgraichen/redmine_dashboard/actions)
[![Rate at redmine.org](http://img.shields.io/badge/rate%20at-redmine.org-blue.svg?style=for-the-badge)](http://www.redmine.org/plugins/redmine-dashboard)
[![Follow at Twitter](http://img.shields.io/badge/follow%20at-twitter-blue.svg?style=for-the-badge)](https://twitter.com/RmDashboard)

This [Redmine](http://redmine.org) plugin adds an issue dashboard that supports drag and drop for issues and various filters.

**Redmine Dashboard 2** is compatible and tested with Redmine 4.1 and 4.0. It may be compatible with older versions too.

![Redmine Dashboard v2.x Screenshot](http://altimos.de/rdb/img/rdb_2-1.png)

## Features List

* Drag-n-drop of issues
* Configurable columns
* Grouping & Filtering
* Group folding
* Hierarchical parent issue view
* Include subproject issues
* Quick edit of assignee and progress

Rate plugin at [redmine.org](http://www.redmine.org/plugins/redmine-dashboard).

## Install

1. Download [latest release](https://github.com/jgraichen/redmine_dashboard/releases).
2. Extract archive to `<redmine>/plugins`. Make **sure** the plugin directory is called `<redmine>/plugins/redmine_dashboard/` ([#11](https://github.com/jgraichen/redmine_dashboard/issues/11)).
3. Install required dependencies by running `bundle install --without development test` in your redmine directory. **Note**: Bitnami and other appliance are not officially supported and may need additional option e.g. `--path vendor/bundle` ([#58](https://github.com/jgraichen/redmine_dashboard/issues/58)).
4. A database migration is not needed. Restart redmine.

### Configure Redmine

1. Add the dashboard module to your project (`Settings > Modules`).
2. Configure dashboard permissions to your user roles (`Administration > Roles and permissions`). Users won't see a Dashboard tab without having the `View Dashboard` permission.

### Upgrade

1. Remove old plugin directory.
2. Follow installation steps for new release.

As of v2 you can also use git by cloning the repository and checkout the release tag.

## Contribute

I appreciate any help and like Pull Requests. The `stable-v2` branch is the current stable branch for v2. The next version, Redmine Dashboard 3, a complete rewrite had been under development on the `master` branch. Due to limited available time the project is in maintenance only mode but open to new contributors.

I gladly accept new translations or language additions for any version of Redmine Dashboard. I would prefer new translations via [Transifex](https://www.transifex.com/projects/p/redmine-dashboard-2/) but you can also send a Pull Request. Feel free to request new languages or to join the team directly on Transfiex.

## License

Redmine dashboard is licensed under the Apache License, Version 2.0.
See LICENSE for more information.
