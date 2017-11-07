# frozen_string_literal: true

class Shoes
  module Swt
    module Font
      class << self
        def add_font(path)
          if File.exist? path
            ::Shoes::Font.add_font_to_fonts(path) if load_font(path)
          end
        end

        def setup_fonts
          # If we've already loaded fonts previously, bail
          return if ::Shoes::FONTS.any?

          load_shoes_fonts
          load_system_fonts
          ::Shoes::FONTS.uniq!
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

        def load_system_fonts
          ::Swt.display.get_font_list(nil, true).each do |font|
            ::Shoes::FONTS << font
          end
        end
      end
    end
  end
end
