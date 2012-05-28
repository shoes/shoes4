require "spec_helper"
require "swt_shoes"
Shoes.configuration.framework = 'swt_shoes'

shared_examples = File.join(File.expand_path(File.dirname(__FILE__)), 'shared_examples', '**/*.rb')
Dir[shared_examples].each { |f| require f }
