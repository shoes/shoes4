class Shoes
  FONT_DIR = DIR + "/fonts/"

  module Font
    FONT_TYPES = "{ttf,ttc,otf,fnt,fon,bdf,pcf,snf,mmm,pfb,pfm}"
    @loaded_fonts = {}

    class << self
      attr_reader :loaded_fonts

      def add_font_names_to_fonts_constant
        Shoes::FONTS.clear
        all_font_source_dirs = system_font_dirs << FONT_DIR
        all_font_source_dirs.each{|dir| load_fonts_from_dir(dir)}
        Shoes::FONTS << @loaded_fonts.keys
        Shoes::FONTS.flatten!
      end

      def load_fonts_from_dir(path)
        Dir.glob(path + "**/*." + FONT_TYPES).each do |font_file|
          add_font(font_file)
        end
      end

      def add_font(path)
        path = path
        name = remove_file_ext(parse_filename_from_path(path))
        load_font(name, path) unless font_already_loaded?(name)
        name
      end

      def load_font(name, path)
        loaded_fonts[name] = path
        Shoes::FONTS << name
      end

      def font_already_loaded?(font_name)
        loaded_fonts.include?(font_name) || Shoes::FONTS.include?(font_name)
      end

      def parse_filename_from_path(file_path)
        Pathname.new(file_path).basename.to_s
      end

      def remove_file_ext(file_name)
        file_name.chomp(File.extname(file_name))
      end

      def system_font_dirs
        case RbConfig::CONFIG['host_os']
          when "darwin"
            ["/System/Library/Fonts/", "/Library/Fonts/" ]
          when "linux", "linux-gnu"
            ["/usr/share/fonts/" , "/usr/local/share/fonts/", Dir.home + "/.fonts/"]
          when /mswin/, "windows", "mingw"
            ["/Windows/Fonts/"]
          else
            raise RuntimeError, "Undetermined Host OS"
        end
      end

    end

    # as soon as this file is loaded populate the FONTS array with fonts
    # maybe we need something like boot.rb for this?
    add_font_names_to_fonts_constant

  end
end
