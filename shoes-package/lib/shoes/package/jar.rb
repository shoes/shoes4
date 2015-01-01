require 'forwardable'
require 'furoshiki/jar'

class Shoes
  module Package
    class Jar
      extend Forwardable

      def_delegators :@packager, :package, :default_dir, :filename

      def initialize(config)
        config.gems << 'shoes-swt'
        @packager = Furoshiki::Jar.new(config)
      end
    end
  end
end
