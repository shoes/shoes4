class Shoes
  module Mock
    class Packager
      def initialize(_dsl)
        @packages = []
      end

      def create_package(_, package)
        @packages << package
      end
    end
  end
end
