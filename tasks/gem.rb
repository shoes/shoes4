require 'bundler/gem_helper'

# Define placeholder tasks so we can name them as dependencies. The bodies
# of these tasks will be defined by Bundler at runtime.
task :build
task :install
task :release

desc 'Build all gems'
task 'build:all'

desc 'Install all gems'
task 'install:all'

desc 'Release all gems'
task 'release:all' => [ 'build:all' ]

['shoes-dsl', 'shoes-swt', 'shoes'].each do |lib|
  # Defer installing Bundler gem tasks until runtime, so we can install them
  # for a particular gem. Still create tasks that will show up in `rake --tasks`
  # Note that executing #install_tasks multiple times will *add* to the defined
  # tasks, so we can build up build:all and install:all tasks.
  task "install_gem_tasks:#{lib}" do
    Bundler::GemHelper.install_tasks :name => lib
  end

  desc "Build the #{lib} gem"
  task "build:#{lib}" => ["install_gem_tasks:#{lib}", :build]

  desc "Install the #{lib} gem"
  task "install:#{lib}" => ["install_gem_tasks:#{lib}", :install]

  desc "Release the #{lib} gem"
  task "release:#{lib}" => ["install_gem_tasks:#{lib}", :release]

  task "build:all" => "install_gem_tasks:#{lib}"
  task "install:all" => "install_gem_tasks:#{lib}"
  task "release:all" => ["release:#{lib}"]
end

task 'build:all' => 'build'
task 'install:all' => 'install'
task 'release:all' => 'release'
