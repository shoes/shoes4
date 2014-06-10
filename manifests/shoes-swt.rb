require_relative 'common'

class ShoesSwtManifest
  extend ShoesManifestReport

  def self.gem_name
    'shoes-swt'
  end

  def self.files
    @files = ShoesCommonManifest.files
      .include(%w[
        lib/shoes/swt.rb
        lib/shoes/swt/**/*
        manifests/shoes-swt.rb
        shoes-swt.gemspec
      ])
      .include(test_files)
  end

  def self.test_files
    @test_files = Rake::FileList['spec/**/*']
  end
end


if $0 == __FILE__
  puts ShoesSwtManifest.report
end
