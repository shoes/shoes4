require 'warbler'
require 'warbler/traits'
require 'warbler/traits/furoshiki'

module Warbler
  module Traits
    # Hack to control the executable
    class NoGemspec
      def update_archive(jar); end
    end

    # Disable this trait, since we are subclassing it (don't run twice)
    class Furoshiki
      def self.detect?; false; end
    end

    class Shoes < Furoshiki
      def self.detect?
        true
      end

      def self.requires?(trait)
        # Actually, it would be better to dump the NoGemspec trait, but since
        # we can't do that, we can at least make sure that this trait gets
        # processed later by declaring that it requires NoGemspec.
        [Traits::Jar, Traits::NoGemspec].include? trait
      end

      def after_configure
        config.init_contents << StringIO.new("require 'shoes'\nShoes.configuration.backend = :swt\n")
      end

      def update_archive(jar)
        super
        add_main_rb(jar, apply_pathmaps(config, default_executable, :application))
      end

      # Uses the `@config.run` if it exists. Otherwise, looks in the
      # application's `bin` directory for an executable with the same name as
      # the jar. If this also fails, defaults to the first executable (alphabetically) in the
      # applications `bin` directory.
      #
      # @return [String] filename of the executable to run
      def default_executable
        return @config.run if @config.run
        exes = Dir['bin/*'].sort
        exe = exes.grep(/#{config.jar_name}/).first || exes.first
        raise "No executable script found" unless exe
        exe
      end
    end
  end
end
