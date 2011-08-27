Redmine Dashboard
=================

Copyright (C) 2011 Jan Graichen

This [Redmine](http://redmine.org) plugin adds an issue dashboard that supports 
drag and drop for issues and various filters and groups.


Install
-------

Clone git repository to `vendor/plugins` and restart redmine. A database 
migration is not needed.


Features
----------

The dashboard columns are the different issue statuses. Closed statuses are 
grouped together in the "Done" column. A dialog where the done status can be 
selected will be shown when dropping an issue on the done column.

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

Filters are saved per project, so you always have your preferred settings 
when changing a project.

Dashboard contains two different view modes: card view and list view. 
Both show issue id, tracker, title, done ratio. Card view also shows 
assignee and version.

**Colors**

- Issue priority is indicated by color of left border.
- Overdue issues are red outlined.

**Options**

- Change assignee to current user when an issue is moved.


Custom Fields
-------------

Dashboard supports two custom fields providing additional information.
If an issue list field named `resolution` exists it will also be shown 
when dropping an issue on "Done". 
A project custom field named `abbreviation` will be used as prefix for issue id.


Supported languages
-------------------
- English
- German


Screenshots
-----------

[![Card view](http://altimos.de/redmine_dashboard/redmine_dashboard.jpg)](http://altimos.de/redmine_dashboard/redmine_dashboard.jpg)


License
-------

Redmine dashboard is licensed under the Apache License, Version 2.0. 
See LICENSE for more information.
