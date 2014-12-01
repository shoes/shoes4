require 'shoes/swt/spec_helper'

describe Shoes::Swt::Font do

  subject {Shoes::Swt::Font}

  describe 'Shoes::FONTS' do
    it 'has the FONTS array initially populared' do
      expect(Shoes::FONTS).not_to be_empty
    end

    it 'loads the 2 shoes specific fonts' do
      expect(Shoes::FONTS).to include("Coolvetica", "Lacuna")
    end
  end

  describe '.add_font' do
    it 'returns nil if no font was found' do
      expect(subject.add_font('/non/existent/font.ttf')).to be_nil
    end

    it 'returns the font name when the font file is present' do
      expect(subject.add_font(Shoes::FONT_DIR + 'Coolvetica.ttf')).to eq 'Coolvetica'
    end

    it 'calls the Display#load_font method' do
      font_path = Shoes::FONT_DIR + 'Coolvetica.ttf'
      expect(::Swt.display).to receive(:load_font).with(font_path)
      subject.add_font font_path
    end
  end
  
end