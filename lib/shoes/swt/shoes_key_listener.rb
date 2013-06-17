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

      def initialize(blk)
        @blk = blk
      end

      # NOTE: state_mask and key_code error for me so the java version is used
      def key_pressed(event)
        key = ''
        key += 'control_' if control?(event)
        key += "alt_" if alt?(event)
        if control?(event)
          # see: http://help.eclipse.org/indigo/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Freference%2Fapi%2Forg%2Feclipse%2Fswt%2Fevents%2FKeyListener.html
          key += event.keyCode.chr if event.keyCode
        else
          key += KEY_NAMES[event.keyCode] || event.character.chr
        end
        key = key.to_sym if other_modifier_keys_than_shift_pressed? event
        @blk.call key if normal_key_pressed?(event)
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

      def normal_key_pressed?(event)
        KEY_NAMES[event.keyCode] || event.character != 0
      end
    end
  end
end
