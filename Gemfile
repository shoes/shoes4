# frozen_string_literal: true

source 'https://rubygems.org'

gem 'shoes',        path: '.'
gem 'shoes-core',   path: 'shoes-core'
gem 'shoes-swt',    path: 'shoes-swt'
gem 'shoes-package', path: 'shoes-package'

gem 'furoshiki', git: 'https://github.com/shoes/furoshiki'

# For local testing, clone to ../furoshiki and use this line instead
# gem 'furoshiki', path: '../furoshiki'

gem 'shoes-manual'
gem 'shoes-highlighter'

group :development do
  gem "guard"
  gem "guard-rspec"
  gem "listen"

  gem "pry"
  gem "pry-nav"

  gem "rspec", "~>3.6.0"
  gem "rspec-its", "~>1.2.0"
  gem "rake"

  gem "rubocop", "0.50.0"

  gem "yard"
  gem "kramdown"
  gem 'simplecov'
  gem "codeclimate-test-reporter", "~> 1.0"
  gem 'webmock'
  gem 'hometown'
  gem 'benchmark-ips'
end
