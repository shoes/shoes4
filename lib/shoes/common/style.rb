class Shoes
  module Common
    # Style methods.
    #
    # Including classes must have instance variable `@style`
    module Style
      # Adds style, or just returns current style if no argument
      #
      # Returns the updated style
      def style(new_styles = nil)
        change_style(new_styles) unless new_styles.nil?
        @style
      end

      private
      def change_style(new_styles)
        @style.merge! new_styles
      end
    end
  end
end
