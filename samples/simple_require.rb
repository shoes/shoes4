# This app tests that we are correctly setting load paths so files in the
# executing directory can be required withour require_relative shenanigans.
require 'require_me'

Shoes.app do
  para RequireMe.message
end
