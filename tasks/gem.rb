require 'bundler/gem_helper'

# Defer installing Bundler gem tasks until runtime, so we can install them
# for a particular gem. Still create tasks that will show up in `rake --tasks`
SUB_GEMS = ['shoes', 'shoes-dsl', 'shoes-swt']
SUB_GEMS.each do |lib|
  task "install_gem_tasks:#{lib}" do
    Bundler::GemHelper.install_tasks :name => lib
  end

  ['build', 'install', 'release'].each do |action|
    # Define a placeholder task so we can name it as a dependency. The body
    # of this task will be defined by Bundler at runtime.
    task action

    desc "#{action.capitalize} the #{lib} gem"
    task "#{action}:#{lib}" => ["install_gem_tasks:#{lib}", action]
  end
end


['build', 'install'].each do |action|
  desc "#{action.capitalize} all gems"
  all_task_name = "#{action}:all"
  task all_task_name

  task all_task_name => SUB_GEMS.map { |lib| "#{action}:#{lib}" }
end

