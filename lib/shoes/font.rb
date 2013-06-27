module Shoes
  FONT_DIR = DIR + "/fonts/"

    # TODO-refactor this to have better names for methods and variables
  class Font
    FONT_TYPES = "{ttf,ttc,otf,fnt,fon,bdf,pcf,snf,mmm,pfb,pfm}"
    attr_reader :path

    def self.fonts_from_dir(path)
      font_names_and_paths = {}
      Dir.glob(path + "*." + FONT_TYPES).each do |font_file|
        font_names_and_paths[remove_file_ext(parse_filename_from_path(font_file))] = font_file
      end
      font_names_and_paths
    end

    def self.system_font_dirs
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

    def self.add_font_names_to_fonts_constant
      Shoes::FONTS.clear
      Shoes::FONTS << fonts_from_dir(FONT_DIR).keys
      system_font_dirs.each do |dir|
        Shoes::FONTS << fonts_from_dir(dir).keys
      end
      Shoes::FONTS.flatten!
    end

    def self.parse_filename_from_path(file_path)
      Pathname.new(file_path).basename.to_s
    end

    def self.remove_file_ext(file_name)
      file_name[0...file_name.rindex('.')]
    end

      # TODO-check for font name or path here this assumes good input
    def initialize(path = '')
      @path = path
      self.class.add_font_names_to_fonts_constant
      @found = find_font
    end

    def find_font
      return false unless available?
      return true if in_folder?
      load_font_from_system
    end

    def available?
      FONTS.include? @path
    end

    def in_folder?
      self.class.fonts_from_dir(FONT_DIR).include? @path
    end

    # TODO-refactor to pull something out of this it is too big
    def load_font_from_system
      fonts_hash = {}
      self.class.system_font_dirs.each do |dir|
        fonts = self.class.fonts_from_dir(dir)
        fonts_hash.merge!(fonts)
      end
      copy_file_to_font_folder(fonts_hash.fetch(@path))
    end

    def copy_file_to_font_folder(file_path)
      new_file_path = Shoes::FONT_DIR + self.class.parse_filename_from_path(file_path)
      FileUtils.cp(file_path, Shoes::FONT_DIR)
      FileUtils.cmp(file_path, new_file_path)
    end

    def found?
      @found
    end

      # TODO-need to work on return value from what is called in builtins
      # TODO-needs to pass tests in textblock spec still after refactor
    def font_name
      return @font_name unless @path == ''
      DEFAULT_TEXTBLOCK_FONT
    end
  end
end
