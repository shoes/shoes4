class Shoes
  module Swt

    module RedrawingAspect

      NEED_TO_FLUSH_GUI  = {Animation   => [:eval_block],
                            Button      => [:eval_block],
                            KeyListener => [:eval_block],
                            Timer       => [:eval_block]}
      NEED_TO_REDRAW_GUI = {::Shoes::App   => [:oval, :star, :line,
                                               :rect, :background, :arc],
                            ::Shoes::Oval  => [:change_style],
                            ::Shoes::Rect  => [:change_style],
                            ::Shoes::Star  => [:change_style],
                            ::Shoes::Shape => [:change_style],
                            ::Shoes::Line  => [:change_style]}

      class << self
        attr_reader :app

        def redraws_for(swt_app)
          @app = swt_app
          extend_needed_classes
          add_redraws
        end

        private
        def extend_needed_classes
          NEED_TO_FLUSH_GUI.keys.each {|klass| klass.extend AfterDo}
          NEED_TO_REDRAW_GUI.keys.each {|klass| klass.extend AfterDo}
        end

        def add_redraws
          after_every NEED_TO_FLUSH_GUI do app.flush end
          after_every NEED_TO_REDRAW_GUI do app.real.redraw end
        end

        def after_every(hash, &blk)
          hash.each {|klass, methods| klass.after methods, &blk }
        end
      end
    end
  end
end