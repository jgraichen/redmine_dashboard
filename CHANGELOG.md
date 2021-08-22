# CHANGELOG

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/) and [Keep a Changelog](http://keepachangelog.com/).


## Unreleased
---

### New

### Changes

### Fixes

### Breaks


## 2.11.0 - (2021-08-22)

### New
* Use CSS native grid for dynamic columns and card width
* Show status name as done column title if only a single closed status is shown
* Include shared versions into filter (#79)
* Only show issue statuses for trackers selected in filter (#108)
* Limit shown statuses to the one available in the project (#121, #127, #130)
* Store dashboard settings in user preferences (#39)

### Changes
* Sort versions in filter (#78)

### Fixes
* Fixed invisible subject in compact card layout
* Duplicated filter items when including subprojects
* Fix possible session cookie overflow as dashboard settings are no longer store in the session (#144)


## 2.10.0 — (2021-07-10)

### New

* Sort groups similar to nested project when grouping by projects (#122)

### Changes

* Diverse performance improvements when querying issues and rendering the dashboard

### Fixes

* Internal server error when grouping by priority (#133)
* Ajax Error: Internal Server Error when grouping by parent issue (#142)

## 2.9.0

### Changes

* New Catalan and Dutch locale
* Updated Turkish locale
* Dropped old Redmine (< 4.0) and Ruby (< 2.5) versions from automated testing

## 2.8.0

### Changes

* Test with Redmine 4.0 and 4.1
* Add new locales bg and pt_BR
* Add support for Redmine 4.0 (experimental)
* Drop old Ruby (< 2.3) and Redmine (< 3.4) versions from automated testing

## 2.7.1

### Changes

* Update locale files (new: ko)

## 2.7.0

### Changes

* Add Mongolian locale
* Update Russian locale
* Add Turkish locale (#102)
* Fix issue with version filter on parent projects (#103, #96)
* Fix/Add overdue handling and styling (#104)
* Small fix for group by parent issue

## 2.6.0

### Changes

* Update for Redmine 3.0

## 2.5.0

### Changes

* Czech translations
* Global YAML configuration file for default view options

## 2.4.0

### Changes

* Integration with ISSUE-ID plugin (#64)
* Update locales (including new Polish translation)

## 2.3.3

### Changes

* Fix error with pluralization patch (#53)
* Update locales
* Bundle transifex utility as gem instead of git repo

## 2.3.2

### Changes

* Fix error with missing pluralization keys (#50):
  Redmine I18n backend does not include a CLDR pluralization rule aware
  pluralize method. Rdb now patches the backend to include
  I18n::Backend::Pluralization as well as Redmines lazy locale load to
  load the pluralization rules.
* Update locales

## 2.3.1

### Changes

* Fix version number

## 2.3.0

### Changes

* New translations

## 2.2.0

### Changes

* Add support for subprojects

## 2.1.0

### Changes

* Include groups to assignee filter (#9)
* Add swimlane for each team member instead of "others" (#18)
* Several bug fixes

## 2.0 (2.0.dev)

### Changes

* New release for Redmine 2.1+
* Improve grouping, swimlanes, filters
* New drop-down menus
* Quick issue editing (progress & assignee only)
* Workflow based column drag'n'drop

## 1.4

### Changes

* Initial release for Redmine 1.4
* Simple task board
* Simple filter and grouping options
