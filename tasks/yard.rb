# frozen_string_literal: true

begin
  require 'yard'

  YARD::Rake::YardocTask.new
rescue LoadError
  desc "Generate YARD Documentation"
  task :yard do
    abort 'YARD is not available. Try: gem install yard'
  end
rescue StandardError => ex
  desc "Generate YARD Documentation"
  task :yard do
    abort "YARD is not available. Error was '#{ex.message}'"
  end
end
