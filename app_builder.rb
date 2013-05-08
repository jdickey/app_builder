
# rails new APPNAME -b app_builder.rb

class AppBuilder < Rails::AppBuilder

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
  end

  def readme
    create_file 'README.md', "## TODO\n"
  end

  def test
    update_gemfile
    generate 'rspec:install'
    remove_file '.rspec'
    create_file '.rspec', "--colour\n-f d"
    generate 'teabag:install'
  end

  private

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
      'vendor/ruby',
      './config/initializers/secret_token.rb'
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
    run 'bundle install --path vendor'
    run 'bundle package --all'
  end

  def update_gems_all_groups
    ['bootstrap-sass',
      'bcrypt-ruby',
      'draper',
      'hashie',
      'haml-rails',
      'configurability',
      'loggability',
      'yajl-ruby',
      'validates_email_format_of',
      'thin'
    ].each do |g|
      self.gem g
    end
  end

  def update_gems_assets
    self.gem_group :assets do
      ['teabag',
        'twitter_bootstrap_form_for',
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
        'meta_request'
      ].each do |g|
        self.gem g
      end
    end
  end

  def update_gems_dev_test
    self.gem_group :development, :test do
      ['inherited_resources',
        'quiet_assets',
        'rspec',
        'rspec-rails',
        'rspec-html-matchers',
        'rspec-http',
        'capybara',
        # 'fuubar',
        'pry',
        'pry-rails',
        'simplecov',
        'factory_girl_rails',
        'jasmine-fixtures'
        # 'pry-doc',
        # 'pry-nav',
        # 'pry-remote',
        # 'pry-stack_explorer',
        # 'pry-exception_explorer'
      ].each do |g|
        self.gem g
      end
    end
  end

  def update_gems_production
    self.gem 'secret_token_replacer', git: 'git://github.com/jdickey/secret_token_replacer.git', group: [:production]
  end

end

