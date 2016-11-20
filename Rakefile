require 'rake'
require 'rake/clean'

require 'rspec/core/rake_task'

require_relative 'tasks/changelog'
require_relative 'tasks/console'
require_relative 'tasks/gem'
require_relative 'tasks/guard'
require_relative 'tasks/rspec'
require_relative 'tasks/sample'
require_relative 'tasks/yard'

PACKAGE_DIR = 'pkg'.freeze

CLEAN.include FileList[PACKAGE_DIR, 'doc', 'coverage', "spec/test_app/#{PACKAGE_DIR}"]
