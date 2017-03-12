# frozen_string_literal: true
class Shoes
  class << self
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
      Shoes.logger.warn "The Shoes.setup method is deprecated, you need to install gems yourself.\n" \
                        "You can do this using the 'gem install' command or bundler and a Gemfile."
      DeprecatedShoesGemSetup.new.instance_eval(&block)
    end

    # Load the backend in memory. This does not set any configuration.
    #
    # @param name [String|Symbol] The name, such as :swt or :mock
    # @return The backend
    def load_backend(name)
      require "shoes/#{name.to_s.downcase}"
      Shoes.const_get(name.to_s.capitalize)
    rescue LoadError => e
      raise LoadError, "Couldn't load backend Shoes::#{name.capitalize}'. Error: #{e.message}\n#{e.backtrace.join("\n")}"
    end
  end

  class DeprecatedShoesGemSetup
    def gem(name)
      name, version = name.split
      install_cmd = 'gem install ' + name
      install_cmd += " --version \"#{version}\"" if version
      Shoes.logger.warn "To use the '#{name}' gem, install it with '#{install_cmd}', and put 'require \"#{name}\"' at the top of your Shoes program.\n" \
                        "Shoes also supports Bundler, so you can provide a 'Gemfile' in your application directory"
    end
  end
end
