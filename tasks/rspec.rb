require 'jruby'
JRuby.runtime.instance_config.runRubyInProcess = false

# thanks Dan Lucraft!
def jruby_run(cmd, swt = false)
  opts = "-J-XstartOnFirstThread" if swt && RbConfig::CONFIG["host_os"] =~ /darwin/

  # see https://github.com/jruby/jruby/wiki/FAQs
  # "How can I increase the heap/memory size when launching a sub-JRuby?"
  sh( "jruby --debug --1.9 -Ispec #{opts} -S #{cmd}" )
end

def rspec(files, options = "")
  rspec_opts = "#{options} #{files}"
  "rspec --tty #{rspec_opts}"
end

# run rspec in separate Jruby JVM
def jruby_rspec(files, args)
  swt = args.delete(:swt)
  rspec_opts = spec_opts_from_args(args)
  rspec_opts << " #{ENV['RSPEC_OPTS']}"

  jruby_run(rspec(files, rspec_opts), swt)
end

def spec_opts_from_args(args)
  opts = []
  opts << "-e ::#{args[:module]}" if args[:module]
  opts += Array(args[:require]).map {|lib| "-r#{lib}"}
  opts += args[:excludes].map { |tag| "--tag ~#{tag}" } if args[:excludes]
  opts += args[:includes].map { |tag| "--tag #{tag}" } if args[:includes]
  opts.join ' '
end

def swt_args(args)
  args = args.to_hash
  args[:swt] = true
  args[:require] = 'shoes-swt/spec/spec_helper'
  # Adjust includes/excludes appropriately
  # args[:includes] = [:swt]
  args[:excludes] = [:no_swt]
  args[:excludes] << :fails_on_osx if RbConfig::CONFIG["host_os"] =~ /darwin/
  args
end

task :default => :spec

desc "Run all specs"
task :spec, [:module] => "spec:all"

namespace :spec do
  desc "Run all specs for Shoes DSL and SWT backend
  Limit the examples to specific :modules :
    Animation
    App
    Button
    Flow

  ie. $ rake spec:all[Flow]
  "
  task "all", [:module] do |t, args|
    Rake::Task["spec:shoes"].invoke(args[:module])
    Rake::Task["spec:swt"].invoke(args[:module])
    Rake::Task["spec:package"].invoke(args[:module])
  end

  task :swt, [:module] do |t, args|
    Rake::Task['spec:swt:all'].invoke(args[:module])
  end

  namespace :swt do
    desc "Run all specs with SWT backend
    Limit the examples to specific :modules : "
    task :all, [:module] do |t, args|
      argh = swt_args(args)
      files = (Dir['shoes-swt/spec/shoes/**/*_spec.rb'] +
               Dir['shoes-core/spec/shoes/**/*_spec.rb']).join ' '
      jruby_rspec(files, argh)
    end

    desc "Run SWT backend specs isolated from DSL"
    task :isolation, [:module] do |t, args|
      argh = swt_args(args)
      files = Dir['shoes-swt/spec/shoes/**/*_spec.rb'].join ' '
      jruby_rspec(files, argh)
    end

    desc "Run DSL specs integrated with SWT backend"
    task :integration, [:module] do |t, args|
      argh = swt_args(args)
      files = Dir['shoes-core/spec/shoes/**/*_spec.rb'].join ' '
      jruby_rspec(files, argh)
    end
  end

  desc "Run specs for Shoes DSL
  Limit the examples to specific :modules : "
  task :core, [:module] do |t, args|
    argh = args.to_hash
    argh[:require] = 'shoes-core/spec/spec_helper'
    files = Dir['shoes-core/spec/shoes/**/*_spec.rb'].join ' '
    jruby_rspec(files, argh)
  end

  # Alias for old-schoolers
  task :dsl => :core

  task :shoes, [:module] do |t, args|
    Rake::Task['spec:dsl'].invoke(args[:module])
  end

  desc "Run specs for Shoes packaging"
  task :package do
    files = Dir['shoes-package/spec/**/*_spec.rb'].join ' '
    jruby_rspec(files, {})
  end
end
