require_relative 'common'

class ShoesHighlighterManifest
  extend ShoesManifestReport

  def self.gem_name
    'shoes-highlighter'
  end

  def self.files
    @files = Rake::FileList[%w(
      Gemfile
      lib/**/*
      shoes-highlighter.gemspec
    )].include(test_files)
  end

  def self.test_files
    @test_files = Rake::FileList['spec/**/*']
  end
end


if $0 == __FILE__
  puts ShoesHighlighterManifest.report
end


