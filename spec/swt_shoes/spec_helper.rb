require "spec_helper"
require "shoes/swt"
# Temporarily use both of these.
Shoes.configuration.framework = 'shoes/swt'
Shoes.configuration.backend = :swt

shared_examples = File.join(File.expand_path(File.dirname(__FILE__)), 'shared_examples', '**/*.rb')
Dir[shared_examples].each { |f| require f }
