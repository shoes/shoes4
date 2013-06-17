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
      KEY_NAMES[::Swt::SWT::BS] = "backspace"
      KEY_NAMES[::Swt::SWT::ESC] = "escape"
      KEY_NAMES[::Swt::SWT::DEL] = "delete"
      KEY_NAMES[::Swt::SWT::CR] = "\n"

      #Modifier keys
      %w[CTRL SHIFT ALT CAPS_LOCK].each do |key|
        KEY_NAMES[eval("::Swt::SWT::#{key}")] = ""
      end

      def initialize(blk)
        @blk = blk
      end

      # NOTE: state_mask and key_code error for me so the java version is used
      def key_pressed(event)
        #Shift-only doesn't count as a modifier
        if other_modifier_keys_than_shift_pressed?(event)
          key = ""

          if control?(event)
            key += "control_"
          end

          if shift?(event)
            key += "shift_"
          end

          if alt?(event)
            key += "alt_"
          end

          key += KEY_NAMES[event.keyCode] || event.character.chr.downcase
          @blk.call key.to_sym

        else
          key = KEY_NAMES[event.keyCode].to_sym if KEY_NAMES[event.keyCode]
          key ||= event.character.chr
          @blk.call key
        end
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

      def shift?(event)
        (event.stateMask & ::Swt::SWT::SHIFT) == ::Swt::SWT::SHIFT
      end

      def control?(event)
        (event.stateMask & ::Swt::SWT::CTRL) == ::Swt::SWT::CTRL
      end
    end
  end
end
