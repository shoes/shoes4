require 'simplecov'
# using coveralls to publish test coverage statistics
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    Coveralls::SimpleCov::Formatter,
    SimpleCov::Formatter::HTMLFormatter
]
SimpleCov.start