# Fix architecture detection so swt jars load correctly. Use
# only until merged upstream and new version of Swt gem is released
# (currently at 0.13)
#
# This must be required before 'swt'
module Swt
  JAR_ROOT = Gem::Specification.find_by_name('swt').gem_dir

  def self.jar_path
    File.join(JAR_ROOT, relative_jar_path)
  end

  def self.relative_jar_path
    case RbConfig::CONFIG["host_os"]
    when /darwin/i
      if %w(amd64 x86_64).include? RbConfig::CONFIG["host_cpu"]
        'vendor/swt/swt-osx64'
      else
        'vendor/swt/swt-osx32'
      end
    when /linux/i
      if %w(amd64 x86_64).include? RbConfig::CONFIG["host_cpu"]
        'vendor/swt/swt-linux64'
      else
        'vendor/swt/swt-linux32'
      end
    when /windows|mswin/i
      if %w(amd64 x86_64).include? RbConfig::CONFIG["host_cpu"]
        'vendor/swt/swt-win64'
      else
        'vendor/swt/swt-win32'
      end
    end
  end

  if File.exist?(jar_path + ".jar")
    require jar_path
  else
    raise "swt jar file required: #{jar_path}.jar"
  end
end

