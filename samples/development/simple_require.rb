# frozen_string_literal: true

#
# This app tests that we are correctly setting load paths so files relative to
# the executing directory can be required withour require_relative shenanigans.
require 'lib/require_me'

Shoes.app do
  para RequireMe.message
end
