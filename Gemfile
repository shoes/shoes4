# frozen_string_literal: true

source 'https://rubygems.org'

gem 'shoes',        path: '.'
gem 'shoes-core',   path: 'shoes-core'
gem 'shoes-package', path: 'shoes-package'
gem 'shoes-swt', path: 'shoes-swt'

gem 'furoshiki', git: 'https://github.com/shoes/furoshiki'

# For local testing, clone to ../furoshiki and use this line instead
# gem 'furoshiki', path: '../furoshiki'

gem 'shoes-highlighter'
gem 'shoes-manual'

group :development do
  gem "guard"
  gem "guard-rspec"
  gem "listen"

  gem "pry"
  gem "pry-debugger-jruby"

  gem "rake"
  gem "rspec", "~>3.6.0"
  gem "rspec-its", "~>1.2.0"

  gem "rubocop", "0.50.0"

  gem 'benchmark-ips'
  gem "codeclimate-test-reporter", "~> 1.0"
  gem 'hometown'
  gem "kramdown"
  gem 'simplecov'
  gem 'webmock'
  gem "yard"
end
