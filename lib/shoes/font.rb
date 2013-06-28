module Shoes
  FONT_DIR = DIR + "/fonts/"

    # TODO-refactor this to have better names for methods and variables
  class Font
    FONT_TYPES = "{ttf,ttc,otf,fnt,fon,bdf,pcf,snf,mmm,pfb,pfm}"
    attr_reader :path, :name
    @@loaded_fonts = {}

      # TODO-check for font name or path here this assumes good input
    def initialize(path)
      @path = path
      @name = remove_file_ext(parse_filename_from_path(@path))
      @@loaded_fonts[@name] = @path
      add_font_names_to_fonts_constant
    end

    def parse_filename_from_path(file_path)
      Pathname.new(file_path).basename.to_s
    end

    def remove_file_ext(file_name)
      file_name.chomp(File.extname(file_name))
    end

    def fonts_from_dir(path)
      font_names = []
      Dir.glob(path + "*." + FONT_TYPES).each do |font_file|
        font_names << remove_file_ext(parse_filename_from_path(font_file))
      end
      font_names
    end

    def system_font_dirs
      case RbConfig::CONFIG['host_os']
        when "darwin"
          return ["/System/Library/Fonts/", "/Library/Fonts/" ]
        when "linux", "linux-gnu"
          return ["/usr/share/fonts/" , "/usr/local/share/fonts/", "~/.fonts/"]
        when "mswin", "windows", "mingw"
          return ["/Windows/Fonts/"]
        else
          raise RuntimeError, "Undetermined Host OS"
      end
    end

    def add_font_names_to_fonts_constant
      Shoes::FONTS.clear
      Shoes::FONTS << fonts_from_dir(FONT_DIR)
      Shoes::FONTS << @@loaded_fonts.keys
      system_font_dirs.each do |dir|
        Shoes::FONTS << fonts_from_dir(dir)
      end
      Shoes::FONTS.flatten!
    end

    def load_font
      return @name unless @path == ''
      DEFAULT_TEXTBLOCK_FONT
    end
  end
end
