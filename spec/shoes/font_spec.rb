require 'spec/shoes/spec_helper'

main_object = self

describe Shoes::Font do

  before :each do
    Shoes.configuration.stub(backend: Shoes::Mock)
    @font = Shoes::Font.new("Helvetica")
  end

  it 'is not nil' do
    @font.should_not be_nil
  end

  it 'saves path passed in to path attribute' do
    @font.path.should == "Helvetica"
  end

  describe 'fonts_from_dir' do
    it 'returns an array of font paths from the dir passed in' do
      Shoes::Font.fonts_from_dir(Shoes::FONT_DIR).should == ["Coolvetica", "Lacuna"]
    end
  end

  describe 'system_font_dirs' do
    it 'returns the path to the systems font directory' do
      Shoes::Font.system_font_dirs.should == ["/System/Library/Fonts/", "/Library/Fonts/" ]
    end
  end

  describe 'parse_font_name_from_path' do
    it 'returns name of file without extension' do
      path = Shoes::FONT_DIR + "Coolvetica.ttf"
      Shoes::Font.parse_font_name_from_path(path).should == "Coolvetica"
    end
  end

  describe '#find_font' do
    it 'checks if the font is currently available' do
      @font.should_receive :available?
      @font.find_font
    end

    it 'checks if available font is in font folder' do
      Shoes::FONTS << "Helvetica"
      @font.should_receive :in_folder?
      @font.find_font
    end
  end

  describe '#available?' do
    it 'returns true if font is in Shoes::FONTS array' do
      @cool_font = Shoes::Font.new("Coolvetica")
      @cool_font.available?.should == true
    end

    it 'returns false if font is not in Shoes::FONTS array' do
      @lost_font = Shoes::Font.new("Knights Who Say Ni")
      @lost_font.available?.should == false
    end
  end

  describe '#in_folder?' do
    it 'returns false if font is not in folder' do
      @font.in_folder?.should == false
    end

    it 'returns true if font is allready in folder' do
      @in_folder_font = Shoes::Font.new("Coolvetica")
      @in_folder_font.in_folder?.should == true
    end
  end
end
