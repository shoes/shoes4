require 'bundler/gem_helper'

desc 'Build all gems'
task 'build:all'
['shoes', 'shoes-dsl', 'shoes-swt'].each do |lib|
  desc "Build the #{lib} gem"
  task "build:#{lib}" do
    Bundler::GemHelper.install_tasks :name => lib
    Rake::Task['build'].invoke
  end

  task 'build:all' => "build:#{lib}"
end

