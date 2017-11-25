# frozen_string_literal: true

require 'rubygems'
require 'fileutils'

# See ext/install/Rakefile for why this cleanup is our responsibility.
# Decide if user uninstalled executables based on our actual Ruby script.
Gem.post_uninstall do |gem|
  uninstalling_shoes = gem.spec.name == "shoes"
  missing_executable = !File.exist?(File.join(Gem.bindir, "shoes-stub")) &&
                       !File.exist?(File.join(Gem.bindir, "shoes-stub.bat"))

  if uninstalling_shoes && missing_executable
    puts "Removing shoes"
    if Gem.win_platform?
      FileUtils.rm(File.join(Gem.bindir, "shoes.bat"))
    else
      FileUtils.rm(File.join(Gem.bindir, "shoes"))
    end

    # Everybody potentially has a generated backend file in their bin
    puts "Removing shoes-backend"
    backend = File.join(Gem.bindir, "shoes-backend")
    FileUtils.rm(backend) if File.exist?(backend)
  end
end
