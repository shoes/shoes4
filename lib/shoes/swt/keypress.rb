module Shoes
  module Swt
    class Keypress
      KEY_NAMES = {}
      
      #Special keys
      %w[TAB PAGE_UP PAGE_DOWN HOME END F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 F13 F14 F15].each{|k| KEY_NAMES[eval("::Swt::SWT::#{k}")] = k.downcase}
      %w[UP DOWN LEFT RIGHT].each{|k| KEY_NAMES[eval("::Swt::SWT::ARROW_#{k}")] = k.downcase} 
      
      KEY_NAMES[::Swt::SWT::DEL] = "delete"
      KEY_NAMES[::Swt::SWT::BS] = "backspace"
      KEY_NAMES[::Swt::SWT::ESC] = "escape"
      KEY_NAMES[::Swt::SWT::DEL] = "delete"
      KEY_NAMES[::Swt::SWT::CR] = "\n"
      
      #Modifier keys
      %w[CTRL SHIFT ALT CAPS_LOCK].each {|k| KEY_NAMES[eval("::Swt::SWT::#{k}")] = ""}
      

      
      def initialize dsl, app, &blk
        @dsl = dsl
        @app = app
        shell = app.shell
        @kl = ::Swt::KeyListener.new.tap do |kl|
          class << kl; self end.
          instance_eval do
            define_method(:keyPressed)do |e|
              #Shift-only doesn't count as a modifier
              if(e.stateMask & (::Swt::SWT::MODIFIER_MASK ^ ::Swt::SWT::SHIFT)) != 0
                key = ""
                
                if (e.stateMask & ::Swt::SWT::CTRL) == ::Swt::SWT::CTRL
                  key += "control_"
                end
                
                if (e.stateMask & ::Swt::SWT::SHIFT) == ::Swt::SWT::SHIFT
                  key += "shift_"
                end
                
                if (e.stateMask & ::Swt::SWT::ALT) == ::Swt::SWT::ALT
                  key += "alt_"
                end
                
                key += KEY_NAMES[e.keyCode] || e.character.chr.downcase
                blk[key.to_sym]
                
              else
                key = KEY_NAMES[e.keyCode].to_sym if KEY_NAMES[e.keyCode]
                key ||= e.character.chr
                blk[key]
              end
            end
            define_method(:keyReleased){|e|}
            define_method(:clear){shell.removeKeyListener kl}
          end
          shell.addKeyListener kl
        end
      end
      
      def clear
        @kl.clear
      end
    end
  end
end
