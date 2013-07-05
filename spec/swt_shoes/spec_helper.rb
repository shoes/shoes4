require "spec_helper"
require "shoes/swt"


shared_examples = File.expand_path('../shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }
