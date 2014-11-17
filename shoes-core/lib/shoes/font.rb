class Shoes
  FONT_DIR = DIR + "/fonts/"

  module Font
    FONT_TYPES = "{ttf,ttc,otf,fnt,fon,bdf,pcf,snf,mmm,pfb,pfm}"
    @loaded_fonts = {}

    class << self
      attr_reader :loaded_fonts

      def font_paths_from_dir(path)
        font_paths = []
        Dir.glob(path + "**/*." + FONT_TYPES).each do |font_path|
          font_paths << font_path
        end
        font_paths
      end

      def add_font(path)
        Shoes.backend::Font.add_font(path)
      end

      def add_font_to_fonts(path)
        name = font_name(path)
        Shoes::FONTS << name
        name
      end

      def initial_fonts
        Shoes.backend::Font.initial_fonts
      end

      private

      def font_name(path)
        remove_file_ext(parse_filename_from_path(path))
      end

      def parse_filename_from_path(file_path)
        Pathname.new(file_path).basename.to_s
      end

      def remove_file_ext(file_name)
        file_name.chomp(File.extname(file_name))
      end
    end
  end

  FONTS = []
end
