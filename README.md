Redmine Dashboard 2
===================

[![Build Status](https://travis-ci.org/jgraichen/redmine_dashboard.png?branch=master)](https://travis-ci.org/jgraichen/redmine_dashboard)

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

Clone git repository to `plugins`, checkout wanted release (`git checkout v2.1.0`) and restart redmine. A database migration is not needed. Run `bundle install` to install required gems.

License
-------

Redmine dashboard is licensed under the Apache License, Version 2.0.
See LICENSE for more information.
