# Packaging caches files in $HOME/.furoshiki/cache by default.
# For testing, we override $HOME using $FUROSHIKI_HOME
FUROSHIKI_SPEC_DIR = Pathname.new(__FILE__).dirname.expand_path.to_s
ENV['FUROSHIKI_HOME'] = FUROSHIKI_SPEC_DIR

SHOES_PACKAGE_SPEC_ROOT= File.expand_path('..', __FILE__)

$LOAD_PATH << File.expand_path(SHOES_PACKAGE_SPEC_ROOT)
$LOAD_PATH << File.expand_path('../../lib', __FILE__)
$LOAD_PATH << File.expand_path('../../../shoes-core/lib', __FILE__)

require 'pathname'
require 'rspec/its'

Dir["#{SHOES_PACKAGE_SPEC_ROOT}/support/**/*.rb"].each {|f| require f}

module PackageHelpers
  # need these values from a context block, so let doesn't work
  def spec_dir
    Pathname.new(__FILE__).join('..').cleanpath
  end

  def input_dir
    spec_dir.join 'support', 'zip'
  end
end

# Guards for running or not running specs. Specs in the guarded block only
# run if the guard conditions are met.
#
module Guard
  # Runs specs only if platform matches
  #
  # @example
  # platform_is :windows do
  #   it "does something only on windows" do
  #     # specification
  #   end
  # end
  def platform_is(platform)
    yield if self.send "platform_is_#{platform}"
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
    yield unless self.send "platform_is_#{platform}"
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
