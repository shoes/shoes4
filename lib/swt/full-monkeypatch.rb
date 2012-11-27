# Use File#expand_path so jars are even when bundled within a jar.
# Use only until merged upstream and new version of Swt gem is
# released (currently at 0.13)
module Swt
  JAR_ROOT = Gem::Specification.find_by_name('swt').gem_dir
end

module JFace
  path = "vendor/jface/*.jar"

  Dir[File.expand_path path, ::Swt::JAR_ROOT].each do |jar_fn|
    require jar_fn
  end
end
