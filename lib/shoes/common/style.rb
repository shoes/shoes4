class Shoes
  module Common
    # Style methods.
    #
    # Including classes must have instance variable `@style`
    module Style
      def style(new_styles = {})
        @style.merge! new_styles
      end
    end
  end
end
