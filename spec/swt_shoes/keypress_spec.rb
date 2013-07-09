require 'swt_shoes/spec_helper'

# note that many important specs for this may be found in
# shoes_key_listener_spec.rb
describe Shoes::Swt::Keypress do
  let(:input_blk) { Proc.new {} }
  let(:opts) { Hash.new }
  let(:app) { double shell: double() }
  let(:dsl) { double('dsl') }
  let(:block) { proc{ |key| key} }
  subject { Shoes::Swt::Keypress.new dsl, app, &block}

  describe "#initialize" do
    it "adds key listener" do
      app.shell.should_receive(:add_key_listener)
      subject
    end
  end
end

describe Shoes::Swt::KeyListener do

  CTRL = ::Swt::SWT::CTRL
  ALT = ::Swt::SWT::ALT
  SHIFT = ::Swt::SWT::SHIFT

  def test_character_press(character, state_modifier = 0, result_char = character)
    block.should_receive(:call).with(result_char)
    event = double  character: character.ord,
                  stateMask: 0 | state_modifier,
                  keyCode: character.downcase.ord
    subject.key_pressed(event)
  end

  def test_alt_character_press(character, state_mask_modifier = 0)
    state_modifier = ALT | state_mask_modifier
    result = ('alt_' + character).to_sym
    test_character_press(character, state_modifier, result)
  end

  let(:block) {double}
  subject {Shoes::Swt::KeyListener.new block}

  describe 'works with simple keys such as' do
    it '"a"' do
      test_character_press 'a'
    end

    it '"1"' do
      test_character_press '1'
    end

    it '"$"' do
      test_character_press '$'
    end
  end

  describe 'works with shift key pressed such as' do
    def test_shift_character_press(character)
      state_modifier = SHIFT
      test_character_press(character, state_modifier)
    end

    it '"A"' do
      test_shift_character_press "A"
    end

    it '"Z"' do
      test_shift_character_press "Z"
    end
  end

  describe 'works with alt key pressed such as' do
    it ':alt_a' do
      test_alt_character_press 'a'
    end

    it ':alt_z' do
      test_alt_character_press 'z'
    end
  end

  describe 'works with the ctrl key pressed such as' do
    def test_ctrl_character_press(character, modifier = 0)
      result_char = ('control_' + character).to_sym
      block.should_receive(:call).with(result_char)
      event = double  character: 'something weird like \x00',
                    stateMask: CTRL | modifier,
                    keyCode: character.downcase.ord
      subject.key_pressed(event)
    end

    it ':ctrl_a' do
      test_ctrl_character_press 'a'
    end

    it 'ctrl_z' do
      test_ctrl_character_press 'z'
    end

    describe 'and if we add the shift key' do
      it ':ctrl_A' do
        test_ctrl_character_press 'A', SHIFT
      end

      it ':ctrl_Z' do
        test_ctrl_character_press 'Z', SHIFT
      end
    end
  end

  describe 'works with shift combined with alt yielding capital letters' do
    def test_alt_shift_character_press(character)
      test_alt_character_press(character, SHIFT)
    end

    it ':alt_A' do
      test_alt_shift_character_press 'A'
    end

    it ':alt_Z' do
      test_alt_shift_character_press 'Z'
    end
  end

  describe 'only modifier keys yield nothing' do
    def test_receive_nothing_with_modifier(modifier, last_key_press = modifier)
      block.should_not_receive :call
      event = double stateMask: modifier, keyCode: last_key_press, character: 0
      subject.key_pressed(event)
    end

    it 'shift' do
      test_receive_nothing_with_modifier SHIFT
    end

    it 'alt' do
      test_receive_nothing_with_modifier ALT
    end

    it 'control' do
      test_receive_nothing_with_modifier CTRL
    end

    it 'shift + ctrl' do
      test_receive_nothing_with_modifier SHIFT | CTRL, SHIFT
    end

    it 'ctrl + alt' do
      test_receive_nothing_with_modifier CTRL | ALT, CTRL
    end

    it 'shift + ctrl + alt' do
      test_receive_nothing_with_modifier CTRL | SHIFT | ALT, ALT
    end
  end

  describe 'special keys' do

    ARROW_LEFT = ::Swt::SWT::ARROW_LEFT

    def special_key_test(code, expected, modifier = 0)
      block.should_receive(:call).with(expected)
      event = double stateMask: modifier,
                   keyCode: code,
                   character: 0
      subject.key_pressed(event)
    end

    it '"\n"' do
      special_key_test(::Swt::SWT::CR, "\n")
    end

    it ':left' do
      special_key_test ARROW_LEFT, :left
    end

    it ':f1' do
      special_key_test ::Swt::SWT::F1, :f1
    end

    it ':tab' do
      special_key_test ::Swt::SWT::TAB, :tab
    end

    it ':delete' do
      special_key_test ::Swt::SWT::DEL, :delete
    end

    describe 'with modifier' do
      it ':alt_left' do
        special_key_test ARROW_LEFT, :alt_left, ALT
      end

      it ':control_left' do
        special_key_test ARROW_LEFT, :control_left, CTRL
      end

      it ':shift_left' do
        special_key_test ARROW_LEFT, :shift_left, SHIFT
      end

      it ':control_alt_home' do
        special_key_test ::Swt::SWT::HOME, :control_alt_home, ALT | CTRL
      end

      it ':control_shift_home' do
        special_key_test ::Swt::SWT::HOME,
                         :control_shift_alt_home,
                         ALT | CTRL | SHIFT
      end
    end
  end

end