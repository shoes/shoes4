require 'rubygems'
require 'rake'
require 'rspec'
require 'facets/hash'

require 'jruby'
JRuby.runtime.instance_config.runRubyInProcess = false

# thanks Dan Lucraft!
def jruby_run(cmd, swt = false)
  opts = "-J-XstartOnFirstThread" if swt && Config::CONFIG["host_os"] =~ /darwin/

  # see https://github.com/jruby/jruby/wiki/FAQs
  # "How can I increase the heap/memory size when launching a sub-JRuby?"
  sh( "jruby --debug --1.9 #{opts} -S #{cmd}" )
end

def rspec(files, options = "")
  rspec_opts = "#{options} #{files}"
  "./bin/rspec --tty #{rspec_opts}"
end

# run rspec in separate Jruby JVM
# options :
#   :swt - true/false(default)  When True, will run Jruby with SWT-required -X-startOnFirstThread
#   :rspec - string  Options to pass to Rspec commandline.
#
def jruby_rspec(files, args)
  swt = args.delete(:swt)
  rspec_opts = spec_opts_from_args(args)
  rspec_opts << " #{ENV['RSPEC_OPTS']}"

  jruby_run(rspec(files, rspec_opts), swt)

  #out = jruby_run(rspec(files, rspec_opts), swt)
  #ok, result = out.split("\n").last
  #examples_failures = result.match /\d* examples, \d* failures/

  #return { :examples => examples_failures[1], :failures => examples_failures[2] }
end

def spec_opts_from_args(args)
  opts = args[:module] ? "-e ::#{args[:module]}" : ""
end

task :default => :spec

desc "Run All Specs"
task :spec, [:module] => "spec:all" do

end

namespace :spec do



  desc "Run All Specs / All Modules"
  task :default => ["spec:all"]

  desc "Run Specs on Shoes + All Frameworks
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
  end

  desc "Specs for SWT Framework 
  Limit the examples to specific :modules : "
  task "swt", [:module] do |t, args|
    argh = args.to_hash
    argh[:swt] = true
    jruby_rspec("spec/swt_shoes/*_spec.rb", argh)
  end

  desc "Specs for base Shoes libraries 
  Limit the examples to specific :modules : "
  task "shoes", [:module] do |t, args|
    argh = args.to_hash
    jruby_rspec("spec/shoes/*_spec.rb", argh)
  end

end
