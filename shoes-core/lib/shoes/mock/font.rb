class Shoes
  module Mock
    module Font
      class << self
        def add_font(path)
          Shoes::Font.add_font_to_fonts path
        end

        def initial_fonts
          []
        end
      end
    end
  end
end
