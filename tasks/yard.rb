# frozen_string_literal: true

begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.files = ['shoes-core/**/*.rb', 'README.md', 'LICENSE', 'CONTRIBUTING.md',
               'CODE_OF_CONDUCT.MD']
    t.options = ['-mmarkdown', '--no-private']
  end
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
