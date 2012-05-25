module Shoes
  module Common
    # Style methods.
    #
    # Requirements
    #
    # @style
    module Style
      def style(new_styles = {})
        @style.merge! new_styles
      end
    end
  end
end
