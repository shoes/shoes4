require 'bundler/gem_helper'

# Defer installing Bundler gem tasks until runtime, so we can install them
# for a particular gem. Still create tasks that will show up in `rake --tasks`
['shoes', 'shoes-dsl', 'shoes-swt'].each do |lib|
  task "install_gem_tasks:#{lib}" do
    Bundler::GemHelper.install_tasks :name => lib
  end

  ['build', 'install', 'release'].each do |action|
    # Define a placeholder task so we can name it as a dependency. The body
    # of this task will be defined by Bundler at runtime.
    task action

    desc "#{action.capitalize} the #{lib} gem"
    task "#{action}:#{lib}" => ["install_gem_tasks:#{lib}", action]

    unless action == 'release'
      desc "#{action.capitalize} all gems"
      task "#{action}:all"

      task "#{action}:all" => "#{action}:#{lib}"
    end
  end
end

