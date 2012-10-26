module Shoes
  module Swt
    class Keypress
      KEY_NAMES = {}
      %w[DEL ESC ALT SHIFT CTRL ARROW_UP ARROW_DOWN ARROW_LEFT ARROW_RIGHT 
        PAGE_UP PAGE_DOWN HOME END INSERT 
        F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 F13 F14 F15].each{|k| KEY_NAMES[eval("::Swt::SWT::#{k}")] = k}
      KEY_NAMES[::Swt::SWT::CR] = "\n"
      
      def initialize dsl, app, &blk
        @dsl = dsl
        @app = app
        shell = app.shell
        @kl = ::Swt::KeyListener.new.tap do |kl|
          class << kl; self end.
          instance_eval do
            define_method(:keyPressed){|e| blk[KEY_NAMES[e.keyCode] || e.character.chr]}
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
