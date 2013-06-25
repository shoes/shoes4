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
      cool = Shoes::FONT_DIR + "Coolvetica.ttf"
      lacu = Shoes::FONT_DIR + "Lacuna.ttf"
      Shoes::Font.fonts_from_dir(Shoes::FONT_DIR).should == [cool, lacu]
    end
  end

  describe 'system_font_dir' do
    it 'returns the path to the systems font directory' do
      RbConfig::CONFIG['host_os'].should == "darwin"
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
