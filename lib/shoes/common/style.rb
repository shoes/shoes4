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
        update_style(new_styles) if need_to_update_style?(new_styles)
        @style
      end

      private
      def update_style(new_styles)
        normalized_style = StyleNormalizer.new.normalize new_styles
        @style.merge! normalized_style
      end

      def need_to_update_style?(new_styles)
        new_styles && style_changed?(new_styles)
      end

      # check necessary because update_style trigger a redraw in the redrawing
      # aspect and we want to avoid unnecessary redraws
      def style_changed?(new_styles)
        new_styles.each_pair.any? do |key, value|
          @style[key] != value
        end
      end
    end
  end
end
