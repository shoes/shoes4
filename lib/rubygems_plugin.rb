require 'rubygems'
require 'fileutils'

# See ext/install/Rakefile for why this cleanup is our responsibility.
# Decide if user uninstalled executables based on our actual Ruby script.
Gem.post_uninstall do |gem|
  uninstalling_shoes = gem.spec.name == "shoes"
  missing_executable = !File.exists?(File.join(Gem.bindir, "ruby-shoes")) &&
                       !File.exists?(File.join(Gem.bindir, "ruby-shoes.bat"))

  if uninstalling_shoes && missing_executable
    puts "Removing shoes"
    if Gem.win_platform?
      FileUtils.rm(File.join(Gem.bindir, "shoes.bat"))
    else
      FileUtils.rm(File.join(Gem.bindir, "shoes"))
    end
  end
end
