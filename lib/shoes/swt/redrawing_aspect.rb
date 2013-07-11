class Shoes
  module Swt

    module RedrawingAspect

      NEED_TO_FLUSH_GUI  = {Animation   => [:eval_block],
                            Button      => [:eval_block],
                            KeyListener => [:eval_block]}
      NEED_TO_REDRAW_GUI = {::Shoes::App   => [:oval, :star, :shape, :line, :rect],
                            ::Shoes::Oval  => [:style],
                            ::Shoes::Rect  => [:style],
                            ::Shoes::Star  => [:style],
                            ::Shoes::Shape => [:style],
                            ::Shoes::Line  => [:style]}

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

        # TODO when to redrawn, when to just flush? figure out differences...
        def add_redraws
          NEED_TO_FLUSH_GUI.each do |klass, methods|
            klass.after methods do app.flush end
          end
          NEED_TO_REDRAW_GUI.each do |klass, methods|
            klass.after methods do app.real.redraw end
          end
        end
      end
    end
  end
end