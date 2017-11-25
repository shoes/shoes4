# frozen_string_literal: true

require 'simplecov'

unless ENV["SHOES_SKIP_COVERAGE"]
  SimpleCov.start do
    add_filter '/spec/'
  end
end
