require 'code_coverage'
require "shoes/swt"
require "spec_helper"


shared_examples = File.expand_path('../shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }
