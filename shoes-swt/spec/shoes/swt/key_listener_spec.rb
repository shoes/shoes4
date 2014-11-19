# encoding: UTF-8
require 'shoes/swt/spec_helper'

describe Shoes::Swt::Keypress do
  let(:app) { double('app', add_key_listener: nil, remove_key_listener: nil) }
  let(:dsl) { double('dsl') }
  let(:block) { proc{ |key| key} }
  let(:key_listener) {Shoes::Swt::Keypress.new(dsl, app, &block)}

  describe '.get_swt_constant' do
    it 'gets the swt constant' do
      expect(Shoes::Swt::KeyListener.get_swt_constant("TAB")).to eq ::Swt::SWT::TAB
    end
  end

  describe "subclasses" do

    describe "Subclass Keypress" do
      it "adds key listener on creation" do
        expect(app).to receive(:add_key_listener)
        Shoes::Swt::Keypress.new dsl, app, &block
      end
    end

    describe "Subclass Keyrelease" do
      it "adds key listener on creation" do
        expect(app).to receive(:add_key_listener)
        Shoes::Swt::Keyrelease.new dsl, app, &block
      end
    end
  end

  it "removes the key listener from the app on remove" do
    key_listener.remove
    expect(app).to have_received(:remove_key_listener).with(key_listener)
  end

  CTRL = ::Swt::SWT::CTRL
  ALT = ::Swt::SWT::ALT
  SHIFT = ::Swt::SWT::SHIFT

  subject {key_listener}

  def test_character_press(character, state_modifier = 0, result_char = character)
    expect(block).to receive(:call).with(result_char)
    event = double  character: character.ord,
                  stateMask: 0 | state_modifier,
                  keyCode: character.downcase.ord
    subject.handle_key_event(event)
  end

  def test_alt_character_press(character, state_mask_modifier = 0)
    state_modifier = ALT | state_mask_modifier
    result = ('alt_' + character).to_sym
    test_character_press(character, state_modifier, result)
  end


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

    it 'handles UTF-8 (œ)' do
      test_character_press 'œ'
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

    it ':alt_/' do
      test_alt_character_press '/'
    end

    it 'works with what Macs seem to produce for opt + / (should be alt_/)' do
      expect(block).to receive(:call).with(:'alt_/')
      event = double  character: '÷'.ord,
                      stateMask: ALT,
                      keyCode: '/'.ord
      subject.handle_key_event(event)
    end
  end

  describe 'works with the ctrl key pressed such as' do
    def test_ctrl_character_press(character, modifier = 0)
      result_char = ('control_' + character).to_sym
      expect(block).to receive(:call).with(result_char)
      event = double character: 'something weird like \x00',
                     stateMask: CTRL | modifier,
                     keyCode:   character.downcase.ord
      subject.handle_key_event(event)
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
      expect(block).not_to receive :call
      event = double stateMask: modifier, keyCode: last_key_press, character: 0
      subject.handle_key_event(event)
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
      expect(block).to receive(:call).with(expected)
      event = double stateMask: modifier,
                   keyCode: code,
                   character: 0
      subject.handle_key_event(event)
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

  describe 'Mac command key' do
    it 'fixes crash of shift option command #584' do
      event = double 'key event', stateMask: 196608,
                                  keyCode: 4194304,
                                  character: "don't care atm"
      expect {subject.handle_key_event(event)}.not_to raise_error
    end
  end

  describe '#ignore_event?' do

    let(:character) {'a'}
    let(:event) {double 'key event',
                        widget: widget,
                        stateMask: 0,
                        keyCode:  keyCode,
                        character: character.ord }
    let(:shell){Java::OrgEclipseSwtWidgets::Shell.new}
    let(:style) {0}
    let(:keyCode) {character.downcase.ord}


    subject{key_listener.ignore_event? event}

    shared_examples_for 'ignores space and enter' do
      describe 'with a space' do
        let(:character) {' '}
        it {is_expected.to be_truthy}
      end

      describe 'with enter' do
        let(:keyCode) {::Swt::SWT::CR}
        it {is_expected.to be_truthy}
      end
    end

    shared_examples_for 'accepts normal characters' do
      describe 'with a normal character' do
        let(:character) {'a'}
        it{is_expected.to be_falsey}
      end
    end

    context 'on a Shell' do
      let(:widget){shell}
      it {is_expected.to be_falsey}

      describe 'even with enter' do
        let(:keyCode) {::Swt::SWT::CR}
        it {is_expected.to be_falsey}
      end
    end

    context 'on a Text' do
      let(:widget){Java::OrgEclipseSwtWidgets::Text.new(shell, style)}
      it {is_expected.to be_truthy}
    end

    context 'on a button' do
      let(:widget) {Java::OrgEclipseSwtWidgets::Button.new(shell, style)}

      it_behaves_like 'ignores space and enter'
      it_behaves_like 'accepts normal characters'
    end

    context 'on a Combo' do
      let(:widget) {Java::OrgEclipseSwtWidgets::Combo.new(shell, style)}

      it_behaves_like 'ignores space and enter'

      describe 'with up' do
        let(:keyCode) {::Swt::SWT::ARROW_UP}
        it{is_expected.to be_truthy}
      end

      it_behaves_like 'accepts normal characters'
    end
  end

end
