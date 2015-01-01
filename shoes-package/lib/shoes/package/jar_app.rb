require 'forwardable'
require 'furoshiki/jar_app'

class Shoes
  module Package
    class JarApp
      extend Forwardable

      def_delegators :@packager, :package, :default_package_dir, :cache_dir,
                                 :remote_template_url, :template_path

      def initialize(config)
        config.gems << 'shoes-swt'
        @packager = Furoshiki::JarApp.new(config)
      end
    end
  end
end
