require 'spec/shoes/spec_helper'
require 'fileutils'

main_object = self

describe Shoes::Font do

  EXAMPLE_FONT_PATH = "/Library/Fonts/SomeFont.ttf"

  before :each do
    @font_name = Shoes::Font.add_font(EXAMPLE_FONT_PATH)
  end

  it 'ends up in loaded fonts' do
    Shoes::Font.loaded_fonts[@font_name].should eq EXAMPLE_FONT_PATH
  end

  it 'parses the path into a font name' do
    @font_name.should == "SomeFont"
  end

  it 'adds the font to the loaded fonts hash' do
    Shoes::Font.loaded_fonts.should include("SomeFont")
  end

  describe 'font method on the main object' do
    it 'returns the name of the font loaded' do
      main_object.font(EXAMPLE_FONT_PATH).should eq 'SomeFont'
    end

    it 'adds SomeFont to the FONTS Array' do
      main_object.font(EXAMPLE_FONT_PATH)
      Shoes::FONTS.should include 'SomeFont'
    end
  end

  describe '.fonts_from_dir' do
    it 'returns an array of the names of the fonts in the directory' do
      Shoes::Font.fonts_from_dir(Shoes::FONT_DIR).should include("Coolvetica", "Lacuna")
    end

    it 'handles sub directories' do
      tmp_font_dir = Shoes::FONT_DIR + 'tmp/'
      Dir.mkdir(tmp_font_dir)
      FileUtils.touch tmp_font_dir + 'weird_font.ttf'
      Shoes::Font.fonts_from_dir(Shoes::FONT_DIR).should include 'weird_font'
      FileUtils.rm_r tmp_font_dir
    end
  end

  describe '.system_font_dirs' do
    def stub_host_os_to(os_identifier)
      stub_const('RbConfig::CONFIG', {'host_os' => os_identifier})
    end

    it 'returns the path to the systems font directory for Mac' do
      stub_host_os_to 'darwin'
      Shoes::Font.system_font_dirs.should == ["/System/Library/Fonts/", "/Library/Fonts/" ]
    end

    it 'returns the path to the systems font directory for Linux' do
      stub_host_os_to 'linux'
      Dir.stub home: '/home/shoes'
      Shoes::Font.system_font_dirs.should == ["/usr/share/fonts/" , "/usr/local/share/fonts/", "/home/shoes/.fonts/"]
    end

    it 'returns the path to systems font directory on Windows' do
      stub_host_os_to 'windows'
      Shoes::Font.system_font_dirs.should == ["/Windows/Fonts/"]
    end
  end

  describe '.parse_filename_from_path' do
    it 'returns name of file with extension' do
      path = "/Library/Fonts/Coolvetica.ttf"
      Shoes::Font.parse_filename_from_path(path).should == "Coolvetica.ttf"
    end
  end

  describe '.remove_file_ext' do
    it 'removes the extension from the filename' do
      Shoes::Font.remove_file_ext("Coolvetica.ttf").should == "Coolvetica"
    end
  end

  describe '.add_font_names_to_fonts_constant' do
    it 'adds font names for fonts found in directories' do
      Shoes::FONTS.clear
      Shoes::Font.add_font_names_to_fonts_constant
      Shoes::FONTS.should_not be_empty
    end
  end

end
