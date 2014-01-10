require 'rubygems'
require 'fileutils'

# See ext/Rakefile for explanation of why this cleanup is our responsibility.
Gem.post_uninstall do
  # Decide if user uninstalled executables based on our actual Ruby script
  unless File.exists?(File.join(Gem.bindir, "ruby-shoes"))
    puts "Removing shoes"
    FileUtils.rm(File.join(Gem.bindir, "shoes"))
  end
end
