require 'simplecov'

# using coveralls to publish test coverage statistics
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter
]
SimpleCov.start

SHOESSPEC_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH << File.join('../lib', SHOESSPEC_ROOT)

require 'rspec'
require 'pry'
require 'shoes'

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

