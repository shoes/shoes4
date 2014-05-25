require 'swt_shoes/spec_helper'

describe Shoes::Swt::Font do

  subject {Shoes::Swt::Font}

  describe 'Shoes::FONTS' do
    it 'has the FONTS array initially populared' do
      Shoes::FONTS.should_not be_empty
    end

    it 'loads the 2 shoes specific fonts' do
      Shoes::FONTS.should include("Coolvetica", "Lacuna")
    end
  end

  describe '.add_font' do
    it 'returns nil if no font was found' do
      subject.add_font('/non/existent/font.ttf').should be_nil
    end

    it 'returns the font name when the font file is present' do
      subject.add_font(Shoes::FONT_DIR + 'Coolvetica.ttf').should eq 'Coolvetica'
    end

    it 'calls the Display#load_font method' do
      font_path = Shoes::FONT_DIR + 'Coolvetica.ttf'
      ::Swt.display.should_receive(:load_font).with(font_path)
      subject.add_font font_path
    end
  end
  
end