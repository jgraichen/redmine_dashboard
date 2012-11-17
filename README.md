Redmine Dashboard 2
===================

This [Redmine](http://redmine.org) plugin adds an issue dashboard that supports drag and drop for issues and various filters.

**Redmine Dashboard 2** is under development for Redmine 2.1. Development version is incomplete and may not be usable for production environment.

Features (planned)
------------------

* Quick edit of issues
* Easy drag-n-drop

**Task Board**

* Configurable columns
* Grouping & Filtering
*
* Hierarchical parent issue view

[![Preview](http://altimos.de/redmine_dashboard/rdb_2-1_t.png)](http://altimos.de/redmine_dashboard/rdb_2-1.png)

**Planning Board**

* Assignee issues to versions, categories or project members
* Easy overview of specific version, category or member

Install
-------

Clone _master_ branch from git repository to `plugins` and restart redmine. A database migration is not needed.

Redmine Dashboard 2.0 is currently under development for Redmine 2.1 and not compatible with earlier versions.


Redmine Dashboard 1.4
=====================

The following applies only to Redmine Dashboard 1.4 available in branch _redmine-1.4_.


Install
-------

Clone branch _redmine-1.4_ from git repository to `vendor/plugins` and restart redmine. A database migration is not needed.

Developed and roughly tested with Redmine 1.2 to 1.4 but may work with other versions.

Features
----------

The dashboard columns are the different issue statuses. Closed statuses are grouped together in the "Done" column. A dialog where the done status can be selected will be shown when dropping an issue on the done column.

The dashboard supports filters to show only a subset of all project issues:

- Version
- Tracker
- All or mine tickets

Issues can be grouped in rows by:

- Tracker
- Priority
- Assignee
- Category
- Version

Filters are saved per project, so you always have your preferred settings when changing a project.

Dashboard contains two different view modes: card view and list view. Both show issue id, tracker, title, done ratio. Card view also shows assignee and version.

**Colors**

- Issue priority is indicated by color of left border.
- Overdue issues are red outlined.

**Options**

- Change assignee to current user when an issue is moved.
- Hide closed issue and resize done column.


Custom Fields
-------------

Dashboard supports two custom fields providing additional information.If an issue list field named `resolution` exists it will also be shown when dropping an issue on "Done". A project custom field named `abbreviation` will be used as prefix for issue id.


Supported languages
-------------------
- English
- German


Screenshots
-----------

[![Card view](http://altimos.de/redmine_dashboard/redmine_dashboard_thumb.png)](http://altimos.de/redmine_dashboard/redmine_dashboard.png)
[![List view](http://altimos.de/redmine_dashboard/redmine_dashboard-list_thumb.png)](http://altimos.de/redmine_dashboard/redmine_dashboard-list.png)


License
-------

Redmine dashboard is licensed under the Apache License, Version 2.0.
See LICENSE for more information.
