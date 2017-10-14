# frozen_string_literal: true

class Shoes
  module Mock
    module Font
      class << self
        def add_font(path)
          Shoes::Font.add_font_to_fonts path
        end
      end
    end
  end
end
