# frozen_string_literal: true

SAMPLES_DIR = "samples"

namespace :samples do
  def samples_from_file(filename)
    samples = File.read("#{SAMPLES_DIR}/#{filename}").lines
    samples.map { |s| s.sub(/#.*$/, '') }.map(&:strip).reject { |s| s == '' }.map { |s| "#{SAMPLES_DIR}/#{s}" }
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

  def run_samples_by_executable(samples, start_with, executable)
    samples.each_with_index do |sample, index|
      next unless index >= start_with

      puts "Running #{sample} (#{index + 1} of #{samples.size})...quit to run next sample"
      system "#{executable} #{sample}"
    end
  end

  def run_samples(samples, start_with = 0)
    if ENV["SHOES_USE_INSTALLED"]
      run_samples_by_executable(samples, start_with, "shoes")
    elsif RbConfig::CONFIG['host_os'] =~ /windows|mswin/i
      run_samples_by_executable(samples, start_with, "bin/shoes")
    else
      system "bin/run-samples #{samples[start_with..-1].join(' ')}"
    end
  end

  desc "Run all working samples in random order"
  task :random do |t|
    puts t.comment
    run_samples working_samples.shuffle
  end

  desc "Run all working samples in alphabetical order"
  task :good, [:start_with] do |t, args|
    puts t.comment
    run_samples working_samples.sort, args[:start_with].to_i
  end

  desc "Run all non-working samples in random order"
  task :bad do |t|
    puts t.comment
    run_samples non_samples.shuffle
  end

  desc "Create list of non-working samples"
  task :bad_list do |t|
    puts t.comment
    non_samples.each { |non_sample| puts non_sample }
  end

  desc "Run all samples listed in samples/filename"
  task :subset, [:filename] do |t, args|
    puts t.comment
    run_samples samples_from_file(args[:filename])
  end
end

task samples: ['samples:random']
task non_samples: ['samples:bad']
task list_non_samples: ['samples:bad_list']
