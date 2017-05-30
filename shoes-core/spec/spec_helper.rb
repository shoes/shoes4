# frozen_string_literal: true
ENV['SHOES_ENV'] = 'test'

SHOESSPEC_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH << File.join(SHOESSPEC_ROOT)
$LOAD_PATH << File.join(SHOESSPEC_ROOT, "../lib")

# loaded again when executing DSL specs with the SWT backend, therefore
# we souldn't start the test coverage again or override the command as it'd
# mess up merging
unless defined?(SimpleCov)
  require_relative '../../spec/code_coverage'
  SimpleCov.command_name 'spec:shoes'
end

require 'rspec'
require 'rspec/its'
require 'pry'
require 'shoes/core'
require 'shoes/ui/cli'
require 'fileutils'
require 'shoes/helpers/fake_element'
require 'shoes/helpers/fake_absolute_element'
require 'shoes/helpers/inspect_helpers'

require 'webmock/rspec'
WebMock.disable_net_connect!(allow: "codeclimate.com")

shared_examples = File.expand_path('../shoes/shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }

RSpec.configure do |config|
  config.before(:each) do
    @prior_fail_fast = Shoes.configuration.fail_fast
    @prior_app_dir = Shoes.configuration.app_dir
  end

  config.after(:each) do
    Shoes.configuration.fail_fast = @prior_fail_fast
    Shoes.configuration.app_dir = @prior_app_dir
  end
end
