# Use File#expand_path so jars are even when bundled within a jar.
# Use only until merged upstream and new version of Swt gem is
# released (currently at 0.13)
module JFace
  path = case Config::CONFIG["host_os"]
    when /windows|mswin/i
      "../../../../swt-*/vendor/jface/*.jar"
    else
      "../../../vendor/jface/*.jar"
    end

  Dir[File.expand_path path, __FILE__].each do |jar_fn|
    require jar_fn
  end
end
