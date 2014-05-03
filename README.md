Redmine Dashboard 2
===================

[![Build Status](https://travis-ci.org/jgraichen/redmine_dashboard.png?branch=master)](https://travis-ci.org/jgraichen/redmine_dashboard)
[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=jgraichen&url=https://github.com/jgraichen/redmine_dashboard&tags=github&category=software)

This [Redmine](http://redmine.org) plugin adds an issue dashboard that supports drag and drop for issues and various filters.

**Redmine Dashboard 2** is compatible with Redmine 2.4 and possibly older versions.

Features List
-------------

* Drag-n-drop of issues
* Configurable columns
* Grouping & Filtering
* Group folding
* Hierarchical parent issue view
* Include subproject issues
* Quick edit of assignee and progress

[![Preview](http://altimos.de/rdb/img/rdb_2-1.png)](http://altimos.de/rdb/img/rdb_2-1.png)

Install
-------

Clone git repository to `plugins`, checkout wanted release (`git checkout v2.2.0`) and restart redmine. A database migration is not needed. Run `bundle install` to install required gems.

Upgrade
-------

Fetch updates (`git fetch --tags`) and checkout newer release (`git checkout v2.2.0`). Run `bundle install` to install newly required gems. A database migration is not needed.

You can list all available version with `git tag -l`.

Contribute
----------

I appreciate any help and like Pull Requests. The `master` branch is the current stable branch for v2. The next version, Redmine Dashboard 3, a complete rewrite is under development on the `develop` branch. Please try to not add larger new features to current v2.

I gladly accept new translations or language additions for any version of Redmine Dashboard. I would prefer new translations via [Transifex](https://www.transifex.com/organization/redmine_dashboard/dashboard) but you can also send a Pull Request. If you want to maintain a translation contact me via IRC (jgraichen at [irc://irc.freenode.net/redmine_dashboard](irc://irc.freenode.net/redmine_dashboard)) or email.

License
-------

Redmine dashboard is licensed under the Apache License, Version 2.0.
See LICENSE for more information.
