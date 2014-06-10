require 'rake'
require 'rake/clean'
require 'rubygems/package_task'
require 'rspec/core/rake_task'

require_relative 'tasks/changelog'
require_relative 'tasks/gem'
require_relative 'tasks/rspec'
require_relative 'tasks/sample'

PACKAGE_DIR = 'pkg'

CLEAN.include FileList[PACKAGE_DIR, 'doc', 'coverage', "spec/test_app/#{PACKAGE_DIR}"]

# Necessary for tasks to have description which is convenient in a few cases
Rake::TaskManager.record_task_metadata = true

begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.options = ['-mmarkdown']
  end
rescue LoadError
  desc "Generate YARD Documentation"
  task :yard do
    abort 'YARD is not available. Try: gem install yard'
  end
end

# spec = Gem::Specification.load('shoes.gemspec')
# Gem::PackageTask.new(spec) do |gem|
#   gem.package_dir = PACKAGE_DIR
# end
