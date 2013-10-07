
## app_builder 0.8.3 (2013-10-08)
  * Added new Gems 'cancan', 'devise', 'rolify' and 'simple_form' to the default group in the Gemfile.
  * Added new Gem 'rubocop' to the :development group in the Gemfile.
  * Added new Gems 'blind', 'capybara-webkit', and 'tapout' to the development-and-test group in the Gemfile.
  * Removed 'jasmine-fixtures' from the development-and-test group in the Gemfile; use Teaspoon's native fixtures instead.
  * Changed the development-and-test group to require the current upstream master repo build of 'database_cleaner'. This works around their [Issue 224](https://github.com/bmabey/database_cleaner/issues/224) which is open against the currently-published Version 1.1.1 as of 8 October.
  * Fixed a typo in the `CHANGELOG.md` for version 0.8.2.
  * Added links to homepages/Github repos of currently-used Gems in `README.md`.

## app_builder 0.8.2 (2013-05-31)

  * Added 'bootswatch-rails' to the "all groups" list in the Gemfile.
  * Added 'database_cleaner' and 'naught' to the development-and-test group, as well as uncommenting 'pry-doc' in that same group.

## app_builder 0.8.1 (2013-05-09)

  * Added Hashie and Draper to the "all groups" list in the Gemfile.

## app_builder 0.8.0 (2013-04-19)

  * Initial release.

