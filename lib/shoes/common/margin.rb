module Shoes
  module Common
    module Margin
      def set_margin
        @margin ||= [0, 0, 0, 0]
        @margin = [@margin, @margin, @margin, @margin] if @margin.is_a? Integer
        margin_left, margin_top, margin_right, margin_bottom = @margin
        @margin_left ||= margin_left
        @margin_top ||= margin_top
        @margin_right ||= margin_right
        @margin_bottom ||= margin_bottom
      end
      attr_accessor :margin, :margin_left, :margin_right, :margin_top, :margin_bottom
    end
  end
end
