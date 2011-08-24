Redmine Dashboard
=================

Copyright (C) 2011 Jan Graichen

This [Redmine](http://redmine.org) plugin adds an issue dashboard that supports 
drag and drop for issues and various filters and groups.


Install
-------

Clone git repository to `vendor/plugins` and restart redmine. A database 
migration is not needed.


How to Use
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

Dashboard contains two different issue views, a card view and a list view. Both
view modes show issue id, tracker, title, done ratio. Card view also shows 
assignee and version.
The border color indicates the issue priority. More important issue will be
shown first in a column.


Custom Fields
-------------

Dashboard supports two custom fields providing additional information.
If an issue list field named `resolution` exists it will also be shown 
when dropping an issue on "Done". A project custom field named `abbreviation` 
will be used as prefix for issue id.


Supported languages
-------------------
- English
- German


Screenshots
-----------

| ![Card view](http://altimos.de/redmine_dashboard/redmine_dashboard-cardview.png) | ![List view](http://altimos.de/redmine_dashboard/redmine_dashboard-listview.png) | ![Grouped by assignee](http://altimos.de/redmine_dashboard/redmine_dashboard-groupassignee.png) |


License
-------

Redmine dashboard is licensed under the Apache License, Version 2.0. 
See LICENSE for more information.
