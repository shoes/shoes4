#require 'simplecov'
#SimpleCov.start

SHOESSPEC_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH << File.join('../lib', SHOESSPEC_ROOT)

require 'rspec'
require 'pathname'
require 'pry'
require 'shoes'

module PackageHelpers
  # need these values from a context block, so let doesn't work
  def spec_dir
    Pathname.new(__FILE__).parent
  end

  def input_dir
    spec_dir.join 'support', 'zip'
  end
end

module ZipHelpers
  include PackageHelpers
  # dir = Pathname.new('spec/support/zip')
  # add_trailing_slash(dir) #=> '/path/to/spec/support/zip/'
  def add_trailing_slash(dir)
    dir.to_s + "/"
  end

  def relative_input_paths(from_dir)
    Pathname.glob(input_dir + "**/*").map do |p|
      directory = true if p.directory?
      relative_path = p.relative_path_from(from_dir).to_s
      relative_path = add_trailing_slash(relative_path) if directory
      relative_path
    end
  end
end

# Guards for running or not running specs. Specs in the guarded block only
# run if the guard conditions are met.
#
# @see Guard#backend_is
module Guard
  # Runs specs only if backend matches given name
  #
  # @example
  # backend_is :swt do
  #   specify "backend_name is :swt" do
  #     # body of spec
  #   end
  # end
  def backend_is(backend)
    yield if Shoes.configuration.backend_name == backend && block_given?
  end

  # Runs specs only if platform matches
  #
  # @example
  # platform_is :windows do
  #   it "does something only on windows" do
  #     # specification
  #   end
  # end
  def platform_is(platform)
    yield if self.send "platform_is_#{platform.to_s}"
  end

  # Runs specs only if platform does not match
  #
  # @example
  # platform_is_not :windows do
  #   it "does something only on posix systems" do
  #     # specification
  #   end
  # end
  def platform_is_not(platform)
    yield unless self.send "platform_is_#{platform.to_s}"
  end

  def platform_is_windows
    return RbConfig::CONFIG['host_os'] =~ /windows|mswin/i
  end

  def platform_is_linux
    return RbConfig::CONFIG['host_os'] =~ /linux/i
  end

  def platform_is_osx
    return RbConfig::CONFIG['host_os'] =~ /darwin/i
  end
end

include Guard

Dir["#{SHOESSPEC_ROOT}/support/**/*.rb"].each {|f| require f}

