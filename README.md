Redmine Dashboard 2
===================

[![Build Status](https://travis-ci.org/jgraichen/redmine_dashboard.png?branch=master)](https://travis-ci.org/jgraichen/redmine_dashboard)

This [Redmine](http://redmine.org) plugin adds an issue dashboard that supports drag and drop for issues and various filters.

**Redmine Dashboard 2** is under development for Redmine 2.1. Development version is incomplete and may not be usable for production environment.

Incomplete Features List
------------------------

* Quick edit of issues
* Easy drag-n-drop

**Task Board**

* Configurable columns
* Grouping & Filtering
* Group folding
* Hierarchical parent issue view

[![Preview](http://altimos.de/redmine_dashboard/rdb_2-1_t.png)](http://altimos.de/redmine_dashboard/rdb_2-1.png)

**Planning Board** (planned)

* Assignee issues to versions, categories or project members
* Easy overview of specific version, category or member

Install
-------

Clone _master_ branch from git repository to `plugins` and restart redmine. A database migration is not needed. Run `bundle install` to install required gems.

Redmine Dashboard 2 is currently under development for Redmine 2.1 and not compatible with earlier versions.

License
-------

Redmine dashboard is licensed under the Apache License, Version 2.0.
See LICENSE for more information.
