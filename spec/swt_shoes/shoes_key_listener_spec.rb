require 'swt_shoes/spec_helper'



describe Shoes::Swt::ShoesKeyListener do

  def test_character_press(character, stub_modifier = {}, result_char = character)
    block.should_receive(:call).with(result_char)
    event = stub({character: character.ord,
                  stateMask: 0,
                  keyCode: nil}.merge(stub_modifier))
    subject.key_pressed(event)
  end

  let(:block) {double}
  subject {Shoes::Swt::ShoesKeyListener.new block}

  describe 'works with simple keys such as' do
    it '"a"' do
      test_character_press 'a'
    end

    it '"1"' do
      test_character_press '1'
    end
  end

  describe 'works with shift key pressed such as' do
    def test_shift_character_press(character)
      state_mask = {stateMask: 0 | ::Swt::SWT::SHIFT}
      test_character_press(character, state_mask)
    end

    it '"A"' do
      test_shift_character_press "A"
    end

    it '"Z"' do
      test_shift_character_press "Z"
    end
  end

  describe 'works with alt key pressed such as' do
    def test_alt_character_press(character)
      state_mask = {stateMask: 0 | ::Swt::SWT::ALT}
      result = ('alt_' + character).to_sym
      test_character_press(character, state_mask, result)
    end

    it ':alt_a' do
      test_alt_character_press 'a'
    end

    it ':alt_z' do
      test_alt_character_press 'z'
    end
  end

  describe 'key aliases' do
    it 'Swt::SWT::CR is "\n"' do
      Shoes::Swt::ShoesKeyListener::KEY_NAMES[::Swt::SWT::CR].should eq("\n")
    end
  end

end