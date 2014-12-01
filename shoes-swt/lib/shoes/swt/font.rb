class Shoes
  module Swt
    module Font
      class << self
        def add_font(path)
          if File.exist? path
            ::Shoes::Font.add_font_to_fonts(path) if load_font(path)
          end
        end

        def initial_fonts
          load_shoes_fonts # system fonts are loaded automatically by SWT
          ::Swt.display.get_font_list(nil, true).map(&:name)
        end

        private

        def load_font(path)
          ::Swt.display.load_font path
        end

        def load_shoes_fonts
          ::Shoes::Font.font_paths_from_dir(::Shoes::FONT_DIR).each do |font_path|
            add_font font_path
          end
        end
      end
    end
  end

  ::Shoes::Font.initial_fonts.each { |font| Shoes::FONTS << font }
end
