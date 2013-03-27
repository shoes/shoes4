require 'rake'
require 'rake/clean'
require 'rubygems/package_task'
require 'rspec/core/rake_task'

PACKAGE_DIR = 'pkg'

CLEAN.include FileList[PACKAGE_DIR, 'doc', 'coverage', "spec/test_app/#{PACKAGE_DIR}"]

require 'jruby'
JRuby.runtime.instance_config.runRubyInProcess = false

# thanks Dan Lucraft!
def jruby_run(cmd, swt = false)
  opts = "-J-XstartOnFirstThread" if swt && Config::CONFIG["host_os"] =~ /darwin/

  # see https://github.com/jruby/jruby/wiki/FAQs
  # "How can I increase the heap/memory size when launching a sub-JRuby?"
  sh( "jruby --debug --1.9 -Ispec #{opts} -S #{cmd}" )
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
  opts = []
  opts << "-e ::#{args[:module]}" if args[:module]
  opts += Array(args[:require]).map {|lib| "-r#{lib}"}
  opts += args[:excludes].map { |tag| "--tag ~#{tag}:true" } if args[:excludes]
  opts += args[:includes].map { |tag| "--tag #{tag}:true" } if args[:includes]
  opts.join ' '
end

def swt_args(args)
  args = args.to_hash
  args[:swt] = true
  args[:require] = 'swt_shoes/spec_helper'
  # Adjust includes/excludes appropriately
  # args[:includes] = [:swt]
  args[:excludes] = [:no_swt]
  args
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

  task :swt, [:module] do |t, args|
    Rake::Task['spec:swt:all'].invoke(args[:module])
  end

  namespace :swt do
    desc "Run all specs with SWT backend
    Limit the examples to specific :modules : "
    task :all, [:module] do |t, args|
      argh = swt_args(args)
      files = (Dir['spec/swt_shoes/*_spec.rb'] + Dir['spec/shoes/*_spec.rb']).join ' '
      jruby_rspec(files, argh)
    end

    desc "Run isolated Swt backend specs"
    task :isolation, [:module] do |t, args|
      argh = swt_args(args)
      files = Dir['spec/swt_shoes/*_spec.rb'].join ' '
      jruby_rspec(files, argh)
    end

    desc "Run integration specs with Swt backend"
    task :integration, [:module] do |t, args|
      argh = swt_args(args)
      files = Dir['spec/shoes/*_spec.rb'].join ' '
      jruby_rspec(files, argh)
    end
  end

  desc "Specs for base Shoes libraries
  Limit the examples to specific :modules : "
  task "shoes", [:module] do |t, args|
    argh = args.to_hash
    files = Dir['spec/shoes/**/*_spec.rb'].join ' '
    jruby_rspec(files, argh)
  end

end

desc "Run all working samples"
task :samples do
  samples_dir = "samples"
  samples = File.read("#{samples_dir}/README").lines
  samples.map {|s| s.sub(/#.*$/, '')}.map(&:strip).select {|s| s != ''}.shuffle.each do |sample|
    puts "Running #{samples_dir}/#{sample}...quit to run next sample"
    cmd = Config::CONFIG["host_os"] =~ /mswin/ ? 'swt-shoooes' : 'shoes'
    system "bin/#{cmd} #{samples_dir}/#{sample}"
  end
end

desc "Run all non-working samples"
task :non_samples do
  samples_dir = "samples"
  samples = File.read("#{samples_dir}/README").lines.map {|s| s.sub(/#.*$/, '')}.map(&:strip).select {|s| s != ''}
  non_samples = Dir[File.join(samples_dir, '*.rb')].map{|f| f.gsub(samples_dir+'/', '')} - samples
  puts "%d Samples are not known to work" % non_samples.count
  p non_samples

  non_samples.shuffle.each do |sample|
    puts "Running #{samples_dir}/#{sample}...quit to run next sample"
    cmd = Config::CONFIG["host_os"] =~ /mswin/ ? 'swt-shoooes' : 'shoes'
    system "bin/#{cmd} #{samples_dir}/#{sample}"
  end
end

begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.options = ['-mmarkdown']
  end
rescue LoadError
  desc "Generate YARD Documentation"
  task :yard do
    abort 'YARD is not available. Try: gem install yard'
  end
end

spec = Gem::Specification.load('shoes.gemspec')
Gem::PackageTask.new(spec) do |gem|
  gem.package_dir = PACKAGE_DIR
end
