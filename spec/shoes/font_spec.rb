require 'spec/shoes/spec_helper'

main_object = self

describe Shoes::Font do

  before :each do
    @font = Shoes::Font.new("/Library/Fonts/Arial.ttf")
  end

  it 'is not nil' do
    @font.should_not be_nil
  end

  it 'saves path passed in to path attribute' do
    @font.path.should == "/Library/Fonts/Arial.ttf"
  end

  it 'parses the path into a font name' do
    @font.name.should == "Arial"
  end

  it 'adds the font to the loaded fonts hash' do
    Shoes::Font.loaded_fonts.should include("Arial")
  end

  describe '#fonts_from_dir' do
    it 'returns an array of the names of the fonts in the directory' do
      @font.fonts_from_dir(Shoes::FONT_DIR).should include("Coolvetica", "Lacuna")
    end
  end

  describe '#system_font_dirs' do
    it 'returns the path to the systems font directory' do
      case RbConfig::CONFIG['host_os']
        when "darwin"
          @font.system_font_dirs.should == ["/System/Library/Fonts/", "/Library/Fonts/" ]
        when "linux", "linux-gnu"
          @font.system_font_dirs.should == ["/usr/share/fonts/" , "/usr/local/share/fonts/", "~/.fonts/"]
        when "mswin", "windows", "mingw"
          @font.system_font_dirs.should == ["/Windows/Fonts/"]
        else
          raise RuntimeError, "Undetermined Host OS"
      end
    end
  end

  describe '#parse_filename_from_path' do
    it 'returns name of file with extension' do
      path = "/Library/Fonts/Coolvetica.ttf"
      @font.parse_filename_from_path(path).should == "Coolvetica.ttf"
    end
  end

  describe '#remove_file_ext' do
    it 'removes the extension from the filename' do
      @font.remove_file_ext("Coolvetica.ttf").should == "Coolvetica"
    end
  end

  describe '#add_font_names_to_fonts_constant' do
    it 'adds font names for fonts found in directories' do
      Shoes::FONTS.clear
      Shoes::FONTS.should == []
      @font.add_font_names_to_fonts_constant
      Shoes::FONTS.should_not == []
    end
  end

  describe "#load_font" do
    it 'returns the font name' do
      @font.load_font.should == "Arial"
    end
  end
end






