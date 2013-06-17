module Shoes
  module Swt
    class ShoesKeyListener
      include ::Swt::KeyListener

      SPECIAL_KEY_NAMES = {}

      #Special keys
      %w[TAB PAGE_UP PAGE_DOWN HOME END F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12
         F13 F14 F15].each do|key|
        SPECIAL_KEY_NAMES[eval("::Swt::SWT::#{key}")] = key.downcase
      end
      %w[UP DOWN LEFT RIGHT].each do |key|
        SPECIAL_KEY_NAMES[eval("::Swt::SWT::ARROW_#{key}")] = key.downcase
      end

      SPECIAL_KEY_NAMES[::Swt::SWT::DEL] = "delete"
      SPECIAL_KEY_NAMES[::Swt::SWT::BS]  = "backspace"
      SPECIAL_KEY_NAMES[::Swt::SWT::ESC] = "escape"
      SPECIAL_KEY_NAMES[::Swt::SWT::CR]  = "\n"

      # modifier keys
      MODIFIER_KEYS = %w[CTRL SHIFT ALT CAPS_LOCK].map do |key|
        eval("::Swt::SWT::#{key}")
      end

      def initialize(blk)
        @block = blk
      end

      # NOTE: state_mask and key_code error for me so the java version is used
      def key_pressed(event)
        modifiers = modifier_keys(event)
        character = character_key(event)
        shoes_key_string = modifiers + character
        shoes_key_string = shoes_key_string.to_sym unless modifiers.empty?
        @block.call shoes_key_string unless character.empty?
      end

      def key_released(event)
      end

      private
      def modifier_keys(event)
        modifier_keys = ''
        modifier_keys += 'control_' if control?(event)
        modifier_keys += 'shift_' if shift?(event) && special_key_pressed?(event)
        modifier_keys += 'alt_' if alt?(event)
        modifier_keys
      end

      def other_modifier_keys_than_shift_pressed?(event)
        (event.stateMask & (::Swt::SWT::MODIFIER_MASK ^ ::Swt::SWT::SHIFT)) != 0
      end

      def alt?(event)
        (event.stateMask & ::Swt::SWT::ALT) == ::Swt::SWT::ALT
      end

      def shift?(event)
        (event.stateMask & ::Swt::SWT::SHIFT) == ::Swt::SWT::SHIFT
      end

      def control?(event)
        (event.stateMask & ::Swt::SWT::CTRL) == ::Swt::SWT::CTRL
      end

      def character_key(event)
        p event.keyCode
        p event.character
        return '' if modifier_key_pressed?(event)
        if special_key_pressed?(event)
          SPECIAL_KEY_NAMES[event.keyCode]
        elsif control?(event)
          event.keyCode.chr if event.keyCode
        else
          event.character.chr if event.character != 0
        end
      end

      def special_key_pressed?(event)
        SPECIAL_KEY_NAMES[event.keyCode]
      end

      def normal_key_pressed?(event)
        special_key_pressed?(event) || event.character != 0
      end

      def modifier_key_pressed?(event)
        MODIFIER_KEYS.include? event.keyCode
      end
    end
  end
end
