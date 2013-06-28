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

  describe '#fonts_from_dir' do
    it 'returns a hash of font names and paths from the dir passed in' do
      @font.fonts_from_dir(Shoes::FONT_DIR).should be_a(Array)
    end

    it 'returns the names of the fonts in the directory' do
      @font.fonts_from_dir(Shoes::FONT_DIR).should == ["Coolvetica", "Lacuna"]
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
    pending "fill this out"
  end

  describe '#add_font_names_to_fonts_constant' do
    pending "fill this out"
  end

  describe "#load_font" do
    pending "fill this out"
  end
end






