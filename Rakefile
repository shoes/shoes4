require 'rake'
require 'rake/clean'
require 'rubygems/package_task'
require 'rspec/core/rake_task'

require_relative 'tasks/changelog'
require_relative 'tasks/gem'
require_relative 'tasks/rspec'

PACKAGE_DIR = 'pkg'
SAMPLES_DIR = "samples"

CLEAN.include FileList[PACKAGE_DIR, 'doc', 'coverage', "spec/test_app/#{PACKAGE_DIR}"]

# Necessary for tasks to have description which is convenient in a few cases
Rake::TaskManager.record_task_metadata = true

desc "Working with samples"
namespace :samples do

  def samples_from_file(filename)
    samples = File.read("#{SAMPLES_DIR}/#{filename}").lines
    samples.map {|s| s.sub(/#.*$/, '')}.map(&:strip).select {|s| s != ''}.map {|s| "#{SAMPLES_DIR}/#{s}"}
  end

  def working_samples
    samples = samples_from_file "README"
    puts "#{samples.size} samples are known to work"
    samples
  end

  def non_samples
    all_samples = Dir[File.join(SAMPLES_DIR, '*.rb')]
    result = all_samples - working_samples
    puts "#{result.size} samples are not known to work"
    result
  end

  def run_sample(sample_name, index, total)
    puts "Running #{sample_name} (#{index + 1} of #{total})...quit to run next sample"
    system "bin/shoes #{sample_name}"
  end

  def run_samples(samples)
    samples.each_with_index do |sample, index|
      run_sample(sample, index, samples.size)
    end
  end

  desc "Run all working samples in random order"
  task :random do |t|
    puts t.comment
    run_samples working_samples.shuffle
  end

  desc "Run all working samples in alphabetical order"
  task :good do |t|
    puts t.comment
    run_samples working_samples.sort
  end

  desc "Run all non-working samples in random order"
  task :bad do |t|
    puts t.comment
    run_samples non_samples.shuffle
  end

  desc "Create list of non-working samples"
  task :bad_list do |t|
    puts t.comment
    non_samples.each{|non_sample| puts non_sample}
  end

  desc "Run all samples listed in samples/filename"
  task :subset, [:filename] do |t, args|
    puts t.comment
    run_samples samples_from_file(args[:filename])
  end
end

task :samples     => ['samples:random']
task :non_samples => ['samples:bad']
task :list_non_samples => ['samples:bad_list']

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

# spec = Gem::Specification.load('shoes.gemspec')
# Gem::PackageTask.new(spec) do |gem|
#   gem.package_dir = PACKAGE_DIR
# end
