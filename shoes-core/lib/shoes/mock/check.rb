# frozen_string_literal: true

class Shoes
  module Mock
    class Check
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(*_opts)
        # SWT backend sets a size, so mimic that in the mock
        super
        @dsl.width ||= 22
      end

      def checked?
        false
      end

      def checked=(*_opts)
      end

      def focus
      end

      def enabled(_value)
      end
    end
  end
end
