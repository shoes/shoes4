SHOESSPEC_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH << File.join('../lib', SHOESSPEC_ROOT)

require 'code_coverage'
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

shared_examples = File.expand_path('../shoes/shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }
