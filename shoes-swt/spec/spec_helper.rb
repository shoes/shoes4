SHOESSPEC_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH << File.join(SHOESSPEC_ROOT)
$LOAD_PATH << File.join(SHOESSPEC_ROOT, '../lib')
$LOAD_PATH << File.join(SHOESSPEC_ROOT, '../../shoes-core/spec')
$LOAD_PATH << File.join(SHOESSPEC_ROOT, '../../shoes-core/lib')

require 'shoes/swt/spec_helper'
require_relative '../../spec/code_coverage'
require 'rspec'
require 'rspec/its'
require 'pry'
require 'shoes'
require 'shoes/ui/cli'
require 'fileutils'
require 'shoes/helpers/fake_element'
require 'shoes/helpers/inspect_helpers'

require 'webmock/rspec'
WebMock.disable_net_connect!(:allow => "codeclimate.com")

shared_examples = File.join(SHOESSPEC_ROOT, '../../shoes-core/spec/shoes/shared_examples/**/*.rb')
Dir[shared_examples].each { |f| require f }
