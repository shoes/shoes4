module Shoes
  module Swt
    class ShoesKeyListener
      include ::Swt::KeyListener

      KEY_NAMES = {}

      #Special keys
      %w[TAB PAGE_UP PAGE_DOWN HOME END F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12
         F13 F14 F15].each do|key|
        KEY_NAMES[eval("::Swt::SWT::#{key}")] = key.downcase
      end
      %w[UP DOWN LEFT RIGHT].each do |key|
        KEY_NAMES[eval("::Swt::SWT::ARROW_#{key}")] = key.downcase
      end

      KEY_NAMES[::Swt::SWT::DEL] = "delete"
      KEY_NAMES[::Swt::SWT::BS]  = "backspace"
      KEY_NAMES[::Swt::SWT::ESC] = "escape"
      KEY_NAMES[::Swt::SWT::CR]  = "\n"

      # modifier keys
      %w[CTRL SHIFT ALT CAPS_LOCK].each do |key|
        KEY_NAMES[eval("::Swt::SWT::#{key}")] = ""
      end

      def initialize(blk)
        @block = blk
      end

      # NOTE: state_mask and key_code error for me so the java version is used
      def key_pressed(event)
        p event.keyCode
        p KEY_NAMES[event.keyCode]
        p event.character
        key = ''
        key += 'control_' if control?(event)
        key += "alt_" if alt?(event)
        key = add_character_to_key(event, key)
        key = key.to_sym if other_modifier_keys_than_shift_pressed? event
        @block.call key if normal_key_pressed?(event)
      end

      def key_released(event)
      end

      private
      def other_modifier_keys_than_shift_pressed?(event)
        (event.stateMask & (::Swt::SWT::MODIFIER_MASK ^ ::Swt::SWT::SHIFT)) != 0
      end

      def alt?(event)
        (event.stateMask & ::Swt::SWT::ALT) == ::Swt::SWT::ALT
      end

      def control?(event)
        (event.stateMask & ::Swt::SWT::CTRL) == ::Swt::SWT::CTRL
      end

      def add_character_to_key(event, key)
        return key if KEY_NAMES[event.keyCode] == ''
        if special_key_pressed?(event)
          key += KEY_NAMES[event.keyCode]
        elsif control?(event)
          key += event.keyCode.chr if event.keyCode
        else
          key += event.character.chr
        end
        key
      end

      def special_key_pressed?(event)
        (KEY_NAMES[event.keyCode] && KEY_NAMES[event.keyCode] != '')
      end

      def normal_key_pressed?(event)
        special_key_pressed?(event) || event.character != 0
      end
    end
  end
end
