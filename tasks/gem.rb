require 'bundler/gem_tasks'

desc 'Build all gems'
task 'build:all'

desc 'Install all gems'
task 'install:all'

desc 'Forcibly uninstall all Shoes gems'
task 'uninstall:all'

desc 'Release all gems'
task 'release:all' => [ 'build:all' ]

['shoes-core', 'shoes-swt', "shoes-package"].each do |lib|
  desc "Build the #{lib} gem"
  task "build:#{lib}" do
    sh "cd ./#{lib} && rake build"
  end

  task "install:#{lib}" do
    sh "cd ./#{lib} && rake install"
  end

  task "uninstall:#{lib}" do
    sh "cd ./#{lib} && gem uninstall -x --force #{lib}"
  end

  task "release:#{lib}" do
    sh "cd ./#{lib} && rake release"
  end

  task "build:all"     => "build:#{lib}"
  task "install:all"   => "install:#{lib}"
  task "uninstall:all" => "uninstall:#{lib}"
  task "release:all"   => "release:#{lib}"
end

# shoes meta-gem gets special handling for build/install scripts
task "build:shoes"   => "build"
task "install:shoes" => "install"
task "release:shoes" => "release"

desc "Uninstall the shoes meta gem"
task "uninstall:shoes" do
  sh "gem uninstall -x --force shoes"
end

task "build:all"     => "build:shoes"
task "install:all"   => "install:shoes"
task "uninstall:all" => "uninstall:shoes"
task "release:all"   => "release:shoes"

desc "Update gem versions based on ./VERSION file. Don't bundle exec"
task :update_versions do
  Dir["**/version.rb"].each do |file|
    version = File.read("./VERSION").chomp

    ruby = File.read(file)
    ruby.gsub!(/^(\s*)VERSION(\s*)= .*?$/, "\\1VERSION = \"#{version}\"")
    raise "Could not insert VERSION in #{file}" unless $1

    File.open(file, 'w') { |f| f.write ruby }
  end
end
