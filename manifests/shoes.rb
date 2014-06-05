require_relative 'common'

class ShoesManifest
  extend ShoesManifestReport

  def self.gem_name
    'shoes'
  end

  def self.files
    @files = ShoesCommonManifest.files
      .include(%w[
        Rakefile
        app.yaml
        benchmark/**/*
        bin/**/*
        ext/**/*
        lib/shoes/ui/**/*
        lib/shoes/version.rb
        manifests/shoes.rb
        samples/**/*
        snapshots/**/*
        static/**/*
        tasks/**/*
        shoes.gemspec
      ])
      .include(test_files)
  end

  def self.test_files
    @test_files = Rake::FileList['spec/shoes/ui/**/*']
  end
end


if $0 == __FILE__
  puts ShoesManifest.report
end

