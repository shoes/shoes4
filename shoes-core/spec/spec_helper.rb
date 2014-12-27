SHOESSPEC_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH << File.join(SHOESSPEC_ROOT)
$LOAD_PATH << File.join(SHOESSPEC_ROOT, "../lib")

require_relative '../../spec/code_coverage'
require 'rspec'
require 'rspec/its'
require 'pry'
require 'shoes/core'
require 'shoes/ui/cli'
require 'fileutils'
require 'shoes/helpers/fake_element'
require 'shoes/helpers/inspect_helpers'

require 'webmock/rspec'
WebMock.disable_net_connect!(:allow => "codeclimate.com")

shared_examples = File.expand_path('../shoes/shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }
