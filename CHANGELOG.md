## 2.7.0

* Add Mongolian locale
* Update Russian locale
* Add Turkish locale (#102)
* Fix issue with version filter on parent projects (#103, #96)
* Fix/Add overdue handling and styling (#104)
* Small fix for group by parent issue

## 2.6.0

* Update for Redmine 3.0

## 2.5.0

* Czech translations
* Global YAML configuration file for default view options

## 2.4.0

* Integration with ISSUE-ID plugin (#64)
* Update locales (including new Polish translation)

## 2.3.3

* Fix error with pluralization patch (#53)
* Update locales
* Bundle transifex utility as gem instead of git repo

## 2.3.2

* Fix error with missing pluralization keys (#50):
  Redmine I18n backend does not include a CLDR pluralization rule aware
  pluralize method. Rdb now patches the backend to include
  I18n::Backend::Pluralization as well as Redmines lazy locale load to
  load the pluralization rules.
* Update locales

## 2.3.1

* Fix version number

## 2.3.0

* New translations

## 2.2.0

* Add support for subprojects

## 2.1.0

* Include groups to assignee filter (#9)
* Add swimlane for each team member instead of "others" (#18)
* Several bug fixes

## 2.0 (2.0.dev)

* New release for Redmine 2.1+
* Improve grouping, swimlanes, filters
* New drop-down menus
* Quick issue editing (progress & assignee only)
* Workflow based column drag'n'drop

## 1.4

* Initial release for Redmine 1.4
* Simple task board
* Simple filter and grouping options
