
# app_builder

## Introduction and Installation

With grateful thanks to [Ryan Bates](https://github.com/ryanb) for Railscast #148, [Custom App Generators (revised)](http://railscasts.com/episodes/148-custom-app-generators-revised?autoplay=true), this repo contains my own app builder which produces a Rails app configured somewhat differently than the default.

To use it, clone this project to your system and/or copy the [`app_builder.rb`](app_builder.rb) file to a convenient place, and run

```
rails new your_project_name -b /path/to/this/app_builder.rb
```

## Effects of this builder rather than the default

1. It adds numerous Gems to the Gemfile before initial bundling, as detailed below;
1. It installs its Gems into `vendor/`, rather than polluting the system Gem repository (or `rvm`/`rbenv` analogue);
1. It optionally creates a "welcome", or landing-page controller and view;
1. It sets up for RSpec BDD rather than Test::Unit TDD, with a customised `.rspec` configuration;
1. It creates a minimal `README.md`, in [Markdown](http://daringfireball.net/projects/markdown/) format rather than [RDoc](http://rdoc.rubyforge.org/);
1. It adds several lines to the `.gitignore` file, involving the Textmate and SublimeText editors, CoffeeScript compiled to JavaScript, the Gem cache and install directories below `vendor/`, and so on.

## Gemfile additions

1. In the default, no-group "group":
  1. `bootstrap-sass`;
  1. `bcrypt-ruby`;
  1. `configurability`;
  1. `haml-rails`;
  1. `loggability`;
  1. `thin`;
  1. `validates_email_format_of`;
  1. `yajl-ruby`.
1. In the `:assets` group:
  1. `execjs`;
  1. `jquery-rails`;
  1. `twitter_bootstrap_form_for`.
1. In the `:development` group:
  1. `better_errors`;
  1. `binding_of_caller`;
  1. `meta_request`.
1. In the `:development` *and* `:test` groups:
  1. `capybara`;
  1. `factory_girl_rails`;
  1. `jasmine_fixtures`;
  1. `pry`;
  1. `pry-rails`;
  1. `quiet_assets`;
  1. `rspec`;
  1. `rspec-html-matchers`;
  1. `rspec-http`;
  1. `rspec-rails`;
  1. `simplecov`;
1. In the `production` group *only*:
  1. `secret_token_replacer`

The `:development` and `:test` groups have commented-out inclusions of five `pry`-related Gems that are either very infrequently used or seem to be linked to segfaults in Ruby;

1. `pry-doc`;
1. `pry-nav`;
1. `pry-remote`;
1. `pry-stack_explorer`;
1. `pry-exception_explorer`;

## Changelog

Please read the [`CHANGELOG.md`](CHANGELOG.md) file.

## Bugs and Feedback

If you discover a possible problem with this builder, please describe it (including your Ruby version, `rvm`/`rbenv` setup, OS and version) in the issues tracker. Searching the issues tracker may allow you to take advantage of others' previous experience with similar problems to your own. Direct any questions to the maintainer to [jeff&#46;dickey&#64;th&#101;&#112;&#114;&#111;log&#46;&#99;o&#109;](mailt&#111;&#58;j&#101;%66%&#54;6&#46;%&#54;&#52;i%63key%&#52;0&#116;h&#101;pr%6Fl&#111;%6&#55;&#46;%&#54;3o%&#54;D) or [j&#100;ic&#107;e&#121;&#64;seven&#45;sig&#109;&#97;&#46;&#99;&#111;m](m&#97;ilto&#58;jdickey&#64;s&#37;&#54;5ve%6E&#45;sigm&#97;&#46;&#99;om).

Patch requests submitted along with are *greatly* appreciated and will be responded to more quickly.

## License

Copyright (c) 2013 Jeff Dickey and Prolog Systems Pte Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

