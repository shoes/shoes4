class Shoes
  module Swt
    class TextBlock
      # Presently centering always takes the whole line, so this class easily
      # allows us to keep those alternate overrides separate from the main
      # flowing text definitions for a segment.
      class CenteredTextSegment < TextSegment
        def initialize(dsl, width)
          super(dsl, dsl.text, width)

          # Centered text always takes all the width it's given
          layout.width = width
        end

        # Overrides to not allow for flowing on final line--whole width only
        def last_line_width
          layout.width
        end
      end
    end
  end
end
