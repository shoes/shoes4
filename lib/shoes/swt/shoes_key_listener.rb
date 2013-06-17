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

      def key_pressed(event)
        #Shift-only doesn't count as a modifier
        if(event.stateMask & (::Swt::SWT::MODIFIER_MASK ^ ::Swt::SWT::SHIFT)) != 0
          key = ""

          if (event.stateMask & ::Swt::SWT::CTRL) == ::Swt::SWT::CTRL
            key += "control_"
          end

          if (event.stateMask & ::Swt::SWT::SHIFT) == ::Swt::SWT::SHIFT
            key += "shift_"
          end

          if (event.stateMask & ::Swt::SWT::ALT) == ::Swt::SWT::ALT
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
    end
  end
end
