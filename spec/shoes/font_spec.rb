require 'spec/shoes/spec_helper'
require 'fileutils'

main_object = self

describe Shoes::Font do
  describe 'font method on the main object' do
    it 'returns the name of the font loaded' do
      result = main_object.font(Shoes::FONT_DIR + "Coolvetica" + '.ttf')
      result.should eq 'Coolvetica'
    end

    it 'calls the backend add_font method' do
      Shoes.backend::Font.should_receive :add_font
      main_object.font 'some/path'
    end
  end

  describe '.font_paths_from_dir' do
    it 'returns an array of the paths of the fonts in the directory' do
      result = Shoes::Font.font_paths_from_dir(Shoes::FONT_DIR)

      result.should include(Shoes::FONT_DIR + 'Coolvetica.ttf',
                            Shoes::FONT_DIR + 'Lacuna.ttf')
    end

    it 'handles sub directories' do
      tmp_font_dir = Shoes::FONT_DIR + 'tmp/'
      Dir.mkdir(tmp_font_dir)
      tmp_font_path = tmp_font_dir + 'weird_font.ttf'
      FileUtils.touch tmp_font_path
      result = Shoes::Font.font_paths_from_dir(Shoes::FONT_DIR)
      result.should include tmp_font_path
      FileUtils.rm_r tmp_font_dir
    end
  end

end
