require 'pathname'
require 'tmpdir'
require 'fileutils'
require 'forwardable'

require 'shoes/common/registration'

class Shoes
  PI = Math::PI
  TWO_PI = 2 * PI
  HALF_PI = 0.5 * PI
  DIR = Pathname.new(__FILE__).join("../..").realpath.to_s
  LOG = []

  extend ::Shoes::Common::Registration

  class << self

    def logger
      Shoes.configuration.logger_instance
    end

    # To ease the upgrade path from Shoes 3 we warn users they need to install
    # and require gems themselves.
    #
    # @example
    #   Shoes.setup do
    #     gem 'bluecloth =2.0.6'
    #     gem 'metaid'
    #   end
    #
    # @param block [Proc] The block that describes the gems that are needed
    # @deprecated
    def setup(&block)
      $stderr.puts "WARN: The Shoes.setup method is deprecated, you need to install gems yourself." +
                   "You can do this using the 'gem install' command or bundler and a Gemfile."
      DeprecatedShoesGemSetup.new.instance_eval(&block)
    end

    # Load the backend in memory. This does not set any configuration.
    #
    # @param name [String|Symbol] The name, such as :swt or :mock
    # @return The backend
    def load_backend(name)
      begin
        require "shoes/#{name.to_s.downcase}"
        Shoes.const_get(name.to_s.capitalize)
      rescue LoadError => e
        raise LoadError, "Couldn't load backend Shoes::#{name.capitalize}'. Error: #{e.message}\n#{e.backtrace.join("\n")}"
      end
    end
  end

  class DeprecatedShoesGemSetup
    def gem(name)
      name, version = name.split()
      install_cmd = 'gem install ' + name
      install_cmd += " --version \"#{version}\"" if version
      $stderr.puts "WARN: To use the '#{name}' gem, install it with '#{install_cmd}', and put 'require \"#{name}\"' at the top of your Shoes program."
    end
  end
end

require 'shoes/version'
require 'shoes/dimensions'

require 'shoes/color'

require 'shoes/common/changeable'
require 'shoes/common/clickable'
require 'shoes/common/common_methods'
require 'shoes/common/fill'
require 'shoes/common/margin'
require 'shoes/common/stroke'
require 'shoes/common/style'
require 'shoes/builtin_methods'
require 'shoes/check_button'
require 'shoes/dsl'
require 'shoes/text'
require 'shoes/input_box'

# please keep this list tidy and alphabetically sorted
require 'shoes/animation'
require 'shoes/app'
require 'shoes/arc'
require 'shoes/background'
require 'shoes/border'
require 'shoes/button'
require 'shoes/configuration'
require 'shoes/color'
require 'shoes/dialog'
require 'shoes/download'
require 'shoes/font'
require 'shoes/gradient'
require 'shoes/image'
require 'shoes/image_pattern'
require 'shoes/key_event'
require 'shoes/line'
require 'shoes/link'
require 'shoes/list_box'
require 'shoes/logger'
require 'shoes/manual'
require 'shoes/oval'
require 'shoes/point'
require 'shoes/progress'
require 'shoes/rect'
require 'shoes/shape'
require 'shoes/slot'
require 'shoes/span'
require 'shoes/star'
require 'shoes/sound'
require 'shoes/text_block'
require 'shoes/timer'
require 'shoes/url'
require 'shoes/widget'
