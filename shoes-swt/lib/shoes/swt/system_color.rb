class Shoes
  module Swt
    class SystemColor < Color

      attr_reader :red, :green, :blue

      def self.create(_dsl, color_name)
        new(color_name)
      end

      def initialize(color_name)
        init_real(color_name)
        @red = @real.red
        @green = @real.green
        @blue = @real.blue
      end

      def init_real(color_name)
        case color_name
        when :system_background
          @real = Shoes.display.getSystemColor(::Swt::SWT::COLOR_WIDGET_BACKGROUND)
        else
          message = "unrecognized system color: #{color_name}"
          fail ArgumentError, message
        end
      end

      def alpha
        ::Shoes::Color::OPAQUE
      end
    end
  end
end
