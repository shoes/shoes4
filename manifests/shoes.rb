require_relative 'common'

class ShoesManifest
  extend ShoesManifestReport

  def self.gem_name
    'shoes'
  end

  def self.files
    # Note we explicitly list files in bin rather than globbing.  Rubygems is
    # unhappy otherwise with symlinks there when building the executable list.
    @files = ShoesCommonManifest.files
      .include(%w[
        Rakefile
        app.yaml
        benchmark/**/*
        bin/shoes-guard
        bin/shoes-stub
        bin/shoes-picker
        ext/**/*
        lib/shoes.rb
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

