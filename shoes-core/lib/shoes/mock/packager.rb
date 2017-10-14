# frozen_string_literal: true

class Shoes
  module Mock
    class Packager
      attr_accessor :gems

      def initialize(*_)
      end

      def options
        OptionParser.new
      end

      def create_package(*_)
      end
    end
  end
end
