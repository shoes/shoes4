require 'rubygems'
require 'fileutils'

# See ext/Rakefile for explanation of why this cleanup is our responsibility.
# Decide if user uninstalled executables based on our actual Ruby script
Gem.post_uninstall do |gem|
  uninstalling_shoes = gem.spec.name == "shoes"
  missing_executable = !File.exists?(File.join(Gem.bindir, "ruby-shoes"))

  if uninstalling_shoes && missing_executable
    puts "Removing shoes"
    FileUtils.rm(File.join(Gem.bindir, "shoes"))
  end
end
