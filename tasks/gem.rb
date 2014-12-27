desc 'Build all gems'
task 'build:all'

desc 'Install all gems'
task 'install:all'

desc 'Forcibly uninstall all Shoes gems'
task 'uninstall:all'

desc 'Release all gems'
task 'release:all' => [ 'build:all' ]

['shoes-core', 'shoes-swt', 'shoes-package', 'shoes'].each do |lib|
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
