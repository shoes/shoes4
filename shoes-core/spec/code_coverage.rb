require 'simplecov'
require "codeclimate-test-reporter"
SimpleCov.start do
  add_filter '/spec/'
end
CodeClimate::TestReporter.start