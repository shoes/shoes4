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

      def self.normalize_style(orig_style)
        normalized_style = {}
        [:fill, :stroke].each do |s|
          normalized_style[s] = Shoes::Color::Helpers.pattern(orig_style[s]) if orig_style[s]
        end
        orig_style.merge(normalized_style)
      end

      private
      def change_style(new_styles)
        normalized_style = Shoes::Common::Style.normalize_style new_styles
        @style.merge! normalized_style
      end
    end
  end
end
