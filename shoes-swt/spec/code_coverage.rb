require 'simplecov'
# using coveralls to publish test coverage statistics
require 'coveralls'
require "codeclimate-test-reporter"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    Coveralls::SimpleCov::Formatter,
    SimpleCov::Formatter::HTMLFormatter
]
SimpleCov.start do
  add_filter '/spec/'
end

CodeClimate::TestReporter.start