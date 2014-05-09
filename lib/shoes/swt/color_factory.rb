class Shoes
  module Swt
    class ColorFactory
      def initialize
        @swt_colors = {}
      end

      def dispose
        @swt_colors.each_value(&:dispose)
        @swt_colors.clear
      end

      def create(color)
        return nil if color.nil?
        return @swt_colors[color] if @swt_colors.include?(color)

        swt_color = ::Shoes.configuration.backend_for(color)
        @swt_colors[color] = swt_color
        swt_color
      end
    end
  end
end
