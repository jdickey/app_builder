
# rails new APPNAME -b app_builder.rb

class AppBuilder < Rails::AppBuilder

  def gitignore
    super
    update_gitignore
  end

  def leftovers
    if yes? "Do you want to generate a root controller?"
      name = ask("What should it be called?").underscore
      generate :controller, "#{name} index"
      route "root to: '#{name}\#index'"
      remove_file "public/index.html"
    end
    git :init
    update_gitignore
    git add: '.', commit: '-m "initial commit"'
    @closing_notes.each {|note| puts 'NOTE: ' + note}
  end

  def readme
    create_file 'README.md', "## TODO\n"
  end

  def test
    update_gemfile
    generate 'rspec:install'
    remove_file '.rspec'
    create_file '.rspec', "--colour\n-f d"
    generate 'teaspoon:install'
    generate 'devise:install'
    @closing_notes ||= []
    @closing_notes << 'You MUST review/edit `config/initializers/devise.rb`.'
    @closing_notes << 'Scroll up and read the other notes from the Devise' +
      ' installation!'
    generate_rubocop_yml
    generate_cruise_rake
  end

  private

  def generate_cruise_rake
    fyle =<<-EOS
    task :cruise do
      system 'rake db:reset'
      system 'rake db:test:clone'
      system 'teaspoon -q -f tap_y | tapout pretty'
      system 'rake spec'

      system 'bin/rubocop -R -f s app spec'
      # system 'rake testoutdated'
    end
    EOS
    create_file 'lib/tasks/cruise.rake', fyle
  end

  # rubocop:disable LineLength
  def generate_rubocop_yml
    fyle =<<-EOS
    # This is the app-wide RuboCop configuration. It should contain *only* the
    # app-wide, always-change-THIS-rule's-settings-to-THAT configuration for
    # the application. Subdirectories which need their own unique directory-wide
    # config should have a .rubocop config [inheriting from this
    # one](https://github.com/bbatsov/rubocop#configuration). Single methods or
    # single lines should have config changes [in
    # comments](https://github.com/bbatsov/rubocop#disabling-cops-within-source-code).
    # Obviously, those should be minimised and treated as a temporarily-tolerated
    # code smell; the long-term solution is to either make the code comply with the
    # the existing "cop" (rule), or disable that rule and write a custom rule that
    # enforces your modifications. (*PLEASE* leave a note of that in a comment atop
    # the affected code!)
    #
    # Also, for each rule overridden here, leave at least a minimal note explaining
    # the reason for the change.
    #
    DefWithoutParentheses:
      Enabled: false  # Python is more readable than PHP. This is why.

    LineLength:
      Max: 80         # default is 79 :-P

    # I don't find the default `true` more readable here, particularly when the last
    # character before the closing brace is a non-alphanumeric character. Chewing up
    # available columns without a noticeable benefit also seems suboptimal. So...
    SpaceInsideHashLiteralBraces:
      EnforcedStyleIsWithSpaces: false

    # Same justification as SpaceInsideHashLiteralBraces, above
    SpaceAroundBlockBraces:
      Enabled: false

    TrailingBlankLines:
      Enabled: false
    EOS
    create_file '.rubocop.yml', fyle
  end
  # rubocop:enable LineLength

  def update_gitignore
    ['*.js.js',
      '*.sublime-project',
      '*.sublime-workspace',
      '*.tmproj',
      '.bundle',
      '.sass-cache/',
      'coverage',
      'db/*.sqlite3',
      'doc/',
      'docs',
      'internal/',
      'log/*.log',
      'tmp/',
      'vendor/cache/*',
      'vendor/cache/**/',
      'vendor/ruby'
    ].each do |s|
      append_file '.gitignore', "#{s.to_s}\n"
    end
  end

  def update_gemfile
    update_gems_all_groups
    update_gems_production
    update_gems_assets
    update_gems_dev
    update_gems_dev_test
    jobs = ENV['BUNDLER_JOBS'] ? "--jobs #{ENV['BUNDLER_JOBS']}" : ''
    run 'bundle install --path vendor ' + jobs
    run 'bundle package --all'
  end

  def update_gems_all_groups
    ['bootstrap-sass',
      'bootswatch-rails',
      'bcrypt-ruby',
      'cancan',
      'devise',
      'draper',
      'hashie',
      'haml-rails',
      'configurability',
      'loggability',
      'rolify',
      'simple_form',
      'yajl-ruby',
      'validates_email_format_of',
      'thin'
    ].each do |g|
      self.gem g
    end
  end

  def update_gems_assets
    self.gem_group :assets do
      ['teaspoon',
        'execjs',
        'jquery-rails'
      ].each do |g|
        self.gem g
      end
      self.gem 'therubyracer', platforms: :ruby
    end
  end

  def update_gems_dev
    self.gem_group :development do
      ['better_errors',
        'binding_of_caller',
        'meta_request',
        'rubocop'
      ].each do |g|
        self.gem g
      end
    end
  end

  def update_gems_dev_test
    self.gem_group :development, :test do
      ['blind',
        'inherited_resources',
        'quiet_assets',
        'rspec',
        'rspec-rails',
        'rspec-html-matchers',
        'rspec-http',
        'capybara',
        'capybara-webkit',
        'naught',
        'pry',
        'pry-rails',
        'simplecov',
        'factory_girl_rails',
        'tapout',
        'pry-doc'
        # 'pry-nav',
        # 'pry-remote',
        # 'pry-stack_explorer',
        # 'pry-exception_explorer'
      ].each do |g|
        self.gem g
      end
      self.gem 'database_cleaner',
        git: 'git://github.com/bmabey/database_cleaner'
      @closing_notes ||= []
      @closing_notes << 'The database_cleaner Gem is being installed from' +
        " the upstream repo master branch. Remove the 'git:' link after" +
        ' version 1.1.1 is replaced in Rubygems.'
    end
  end

  def update_gems_production
    # self.gem 'secret_token_replacer',
    #   git: 'git://github.com/jdickey/secret_token_replacer.git',
    #   group: [:production]
  end

  # This builds a URL to 'build' a custom jQuery++ version containing the
  # *COMPLETE* set of DOM helpers and event-listener helpers. As of Version
  # 1.0.1, this is a ginormous 159K *uncompressed*. If you don't *need*
  # all 18 modules, go over to http://jquerypp.com/ and build your own
  # `jquerypp.custom.js` with just the components you need. You'll then want to
  # compress or "minify" the file, which you can do at
  # http://compressorrater.thruhere.net/ using several different compressors for
  # comparison purposes.
  def jquerypp_builder_url
    dom_plugins = [
      'animate',
      'compare',
      'cookie',
      'dimensions',
      'form_params',
      'range',
      'selection',
      'styles',
      'within'
      ]
    event_plugins = [
      'destroyed',
      'drag',
      'drop',
      'fastfix',
      'hover',
      'key',
      'pause',
      'resize',
      'swipe'
    ]
    ret = 'http://bitbuilder.herokuapp.com/jquerypp.custom.js?'
    dom_plugins.each{|p| ret += 'plugins=jquerypp/dom/' + p + '&'}
    event_plugins.each{|p| ret += 'plugins=jquerypp/event/' + p + '&'}
    ret.chomp('&')
  end

  def ba_url
    ba_base = 'https://raw.github.com/cowboy/javascript-debug/master/'
    ba_base + 'ba-debug.min.js'
  end

  def moo_url
    'http://mootools.net/download/get/mootools-core-1.4.5-full-compat.js'
  end

  def outer_html_url
    'http://www.darlesson.com/plugins/OuterHTML/source/outerHTML-2.1.0-min.js'
  end

  def underscore_url(ext)
    'https://raw.github.com/jashkenas/underscore/master/underscore-min.' + ext
  end

  def vendor_javascripts
    vajs = 'vendor/assets/javascripts/'
    empty_directory vajs
    [
      ba_url,
      moo_url,
      outer_html_url,
      underscore_url('js'),
      underscore_url('map')
    ].each do |url|
      get url, vajs + File.basename(url)
    end
    url = jquerypp_builder_url
    get url, vajs + 'jquerypp.custom.js'
  end

end
