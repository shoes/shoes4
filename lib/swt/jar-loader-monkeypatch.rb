# Fix architecture detection so swt jars load correctly. Use
# only until merged upstream and new version of Swt gem is released
# (currently at 0.13)
module Swt
  def self.relative_jar_path
    case Config::CONFIG["host_os"]
    when /darwin/i
      if %w(amd64 x86_64).include? Config::CONFIG["host_cpu"]
        '../../../vendor/swt/swt-osx64'
      else
        '../../../vendor/swt/swt-osx32'
      end
    when /linux/i
      if %w(amd64 x86_64).include? Config::CONFIG["host_cpu"]
        '../../../vendor/swt/swt-linux64'
      else
        '../../../vendor/swt/swt-linux32'
      end
    when /windows|mswin/i
      if %w(amd64 x86_64).include? Config::CONFIG["host_cpu"]
        '../../../vendor/swt/swt-win64'
      else
        '../../../vendor/swt/swt-win32'
      end
    end
  end
end

