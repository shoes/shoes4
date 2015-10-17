class Shoes
  module Swt
    class SystemColor < Color
      def initialize(color_name)
        @dsl = color_name
        case color_name
        when :system_background
          @real = Shoes.display.getSystemColor(::Swt::SWT::COLOR_WIDGET_BACKGROUND)
        else
          message = "unrecognized system color: #{color_name}"
          fail ArgumentError, message
        end
      end
    end
  end
end
