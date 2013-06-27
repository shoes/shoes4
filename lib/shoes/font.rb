module Shoes
  FONT_DIR = DIR + "/fonts/"

    # TODO-refactor this to have better names for methods and variables
  class Font
    FONT_TYPES = "{ttf,ttc,otf,fnt,fon,bdf,pcf,snf,mmm,pfb,pfm}"
    attr_reader :font_path, :font_name

      # TODO-check for font name or path here this assumes good input
    def initialize(font_path)
      @font_path = font_path
      @font_name = remove_file_ext(parse_filename_from_path(@font_path))
      add_font_names_to_fonts_constant
    end

    def parse_filename_from_path(file_path)
      Pathname.new(file_path).basename.to_s
    end

    def remove_file_ext(file_name)
      file_name.chomp(File.extname(file_name))
    end

    def fonts_from_dir(path)
      font_names_and_paths = {}
      Dir.glob(path + "*." + FONT_TYPES).each do |font_file|
        font_names_and_paths[remove_file_ext(parse_filename_from_path(font_file))] = font_file
      end
      font_names_and_paths
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
      Shoes::FONTS << fonts_from_dir(FONT_DIR).keys
      system_font_dirs.each do |dir|
        Shoes::FONTS << fonts_from_dir(dir).keys
      end
      Shoes::FONTS.flatten!
    end

    def load_font
      return @font_name unless @path == ''
      DEFAULT_TEXTBLOCK_FONT
    end
  end
end

__END__
take a path in
grab the font name from the path
store font name and path in hash
update FONTS with newly loaded font name

