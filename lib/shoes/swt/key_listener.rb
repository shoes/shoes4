class Shoes
  module Swt
    class KeyListener
      include ::Swt::KeyListener

      def self.get_swt_constant(name)
        ::Swt::SWT.const_get name
      end

      SPECIAL_KEY_NAMES = {}

      %w(TAB PAGE_UP PAGE_DOWN HOME END F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12
         F13 F14 F15).each do|key|
        SPECIAL_KEY_NAMES[get_swt_constant key] = key.downcase
      end
      %w(UP DOWN LEFT RIGHT).each do |key|
        SPECIAL_KEY_NAMES[get_swt_constant "ARROW_#{key}"] = key.downcase
      end

      SPECIAL_KEY_NAMES[::Swt::SWT::DEL] = "delete"
      SPECIAL_KEY_NAMES[::Swt::SWT::BS]  = "backspace"
      SPECIAL_KEY_NAMES[::Swt::SWT::ESC] = "escape"
      SPECIAL_KEY_NAMES[::Swt::SWT::CR]  = "\n"

      MODIFIER_KEYS = %w(CTRL SHIFT ALT CAPS_LOCK COMMAND).map do |key|
        get_swt_constant key
      end

      def initialize(_dsl, app, &blk)
        @block = blk
        @app = app
        @app.add_key_listener(self)
      end

      def handle_key_event(event)
        modifiers = modifier_keys(event)
        character = character_key(event)
        key_string = modifiers + character
        key_string = key_string.to_sym if should_be_symbol?(event, modifiers)
        eval_block key_string unless character.empty?
      end

      def remove
        @app.remove_key_listener(self)
      end

      BUTTON_EXCLUDES = ["\n", " "]
      COMBO_EXCLUDES  = %w(up down) + BUTTON_EXCLUDES

      # For a variety of SWT controls, certain characters should not be passed
      # to Shoes key listeners, since they're already handled by the controls.
      #
      #   * Buttons ignore activating key press (enter, space depending on OS)
      #   * Text boxes ignore all key presses
      #   * Combo boxes ignore up/down and activating key presses
      def ignore_event?(event)
        char = character_key(event)
        case event.widget
        when Java::OrgEclipseSwtWidgets::Button
          BUTTON_EXCLUDES.include?(char)
        when Java::OrgEclipseSwtWidgets::Text
          true
        when Java::OrgEclipseSwtWidgets::Combo
          COMBO_EXCLUDES.include?(char)
        else
          # Default? Don't ignore it!
          false
        end
      end

      private

      def eval_block(key_string)
        @block.call key_string
      end

      def modifier_keys(event)
        modifier_keys = ''
        modifier_keys += 'control_' if control?(event)
        modifier_keys += 'shift_' if shift?(event) && special_key?(event)
        modifier_keys += 'alt_' if alt?(event)
        modifier_keys
      end

      def alt?(event)
        is_this_modifier_key?(event, ::Swt::SWT::ALT)
      end

      # NOTE: state_mask and key_code error for me so the java version is used
      def is_this_modifier_key?(event, key)
        (event.stateMask & key) == key
      end

      def shift?(event)
        is_this_modifier_key?(event, ::Swt::SWT::SHIFT)
      end

      def control?(event)
        is_this_modifier_key?(event, ::Swt::SWT::CTRL)
      end

      def character_key(event)
        return '' if current_key_is_modifier?(event)
        if special_key?(event)
          SPECIAL_KEY_NAMES[event.keyCode]
        elsif control?(event) || alt?(event)
          character_for_modified_keypress(event)
        else
          event.character.chr('UTF-8')
        end
      end

      def character_for_modified_keypress(event)
        character = event.keyCode.chr('UTF-8')
        if shift?(event)
          character.upcase
        else
          character
        end
      end

      def special_key?(event)
        SPECIAL_KEY_NAMES[event.keyCode]
      end

      def current_key_is_modifier?(event)
        MODIFIER_KEYS.include? event.keyCode
      end

      def should_be_symbol?(event, modifiers)
        !modifiers.empty? || (special_key?(event) && !enter?(event))
      end

      def enter?(event)
        event.keyCode == ::Swt::SWT::CR
      end
    end

    class Keypress < KeyListener
    end

    class Keyrelease < KeyListener
    end
  end
end
