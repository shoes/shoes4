module Shoes
  class Font
    def initialize(path = '')
      @path = path

    end

    def font_name
      return @font_name unless @path == ''
      DEFAULT_TEXTBLOCK_FONT
    end
  end
end


__END__

# according to PragTob this method is used to load fonts
# and it should receive a path to the font that needs to be loaded
# this font should probably be copied into the fonts folder
# HacketyHack had the fonts dir as a global HH::FONTS
# should add a global SHOES::FONTS or something
#
# this should be added in the lib/shoes/dsl.rb
# as it is a DSL method
#
# there is a fonts folder that maybe should be checked for existing fonts
# then if not in the folder then load from path passed into methad
#OS X stores fonts in /System/Library/Fonts/
#Windows stores fonts in /Windows/Fonts/
#Linux use fc-match @font to find path to font
#can check RUBY_PLATFORM
#/mingw/
#/darwin/
