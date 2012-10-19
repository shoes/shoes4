# Use File#expand_path so jars are even when bundled within a jar.
# Use only until merged upstream and new version of Swt gem is
# released (currently at 0.13)
module JFace
  Dir[File.expand_path "../../../vendor/jface/*.jar", __FILE__].each do |jar_fn|
    require jar_fn
  end
end


