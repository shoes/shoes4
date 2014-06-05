require 'rake/file_list'

module ShoesManifestReport
  def report
    puts "Manifest of #{gem_name} gem"
    puts
    puts "files"
    puts "-----"
    puts files.sort.join("\n")
    puts
    puts "test_files"
    puts "----------"
    puts test_files.sort.join("\n")
    puts
    puts "#{files.length} files, #{test_files.length} test_files"
  end
end

class ShoesCommonManifest
  def self.files
    Rake::FileList[%w(
      CHANGELOG
      Gemfile
      Guardfile
      LICENSE
      README.md
    )]
  end

  def self.test_files
    []
  end
end
