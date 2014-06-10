require 'rake'
require 'rake/clean'
require 'rubygems/package_task'
require 'rspec/core/rake_task'

require_relative 'tasks/changelog'
require_relative 'tasks/gem'
require_relative 'tasks/rspec'
require_relative 'tasks/sample'
require_relative 'tasks/yard'

PACKAGE_DIR = 'pkg'

CLEAN.include FileList[PACKAGE_DIR, 'doc', 'coverage', "spec/test_app/#{PACKAGE_DIR}"]

# Necessary for tasks to have description which is convenient in a few cases
Rake::TaskManager.record_task_metadata = true


# spec = Gem::Specification.load('shoes.gemspec')
# Gem::PackageTask.new(spec) do |gem|
#   gem.package_dir = PACKAGE_DIR
# end
