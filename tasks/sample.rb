# frozen_string_literal: true

SAMPLES_DIR = "samples"

namespace :samples do
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

  def working_samples
    Dir["#{SAMPLES_DIR}/*.rb"]
  end

  def all_samples
    Dir["#{SAMPLES_DIR}/**/*.rb"]
      .reject { |path| path.include?("#{SAMPLES_DIR}/development/lib") }
      .reject { |path| path.include?("#{SAMPLES_DIR}/packaging/star_wars/characters") }
      .reject { |path| path.include?("#{SAMPLES_DIR}/unsupported") }
  end

  desc "Run all working samples in random order"
  task :random do |t|
    puts t.comment
    puts working_samples
    run_samples working_samples.shuffle
  end

  desc "Run all working samples, even in subdirectories"
  task :all do |t|
    puts t.comment
    puts all_samples
    run_samples all_samples.shuffle
  end
end

task samples: ['samples:random']
