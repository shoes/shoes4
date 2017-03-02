# frozen_string_literal: true
class Shoes
  module Mock
    class Packager
      attr_accessor :gems

      def initialize(_dsl)
        @packages = []
      end

      def create_package(_, package)
        @packages << package
      end
    end
  end
end
