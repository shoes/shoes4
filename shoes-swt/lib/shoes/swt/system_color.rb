class Shoes
  module Swt
    class SystemColor < Color
      def initialize(color_name)
        case color_name
        when :system_background
          @real = Shoes.display.getSystemColor(::Swt::SWT::COLOR_WIDGET_BACKGROUND)
        else
          message = "unrecognized system color: #{color_name}"
          fail ArgumentError, message
        end
      end

      def alpha
        Shoes::Color::OPAQUE
      end
    end
  end
end
