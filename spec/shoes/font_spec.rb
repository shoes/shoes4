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

  describe '#find_fonts' do
    it 'checks if font is allready in font folder' do
      @font.should_receive :in_folder?
      @font.find_fonts
    end
  end

  describe '#in_folder?' do
    it 'returns false if font is not in folder' do
      @font.in_folder?.should == false
    end

    it 'returns true if font is allready in folder' do
      @in_folder_font = Shoes::Font.new("Collvetica")
      @in_folder_font.in_folder?.should == true
    end
  end
end
