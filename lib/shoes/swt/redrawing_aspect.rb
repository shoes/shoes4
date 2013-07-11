class Shoes
  module Swt

    module RedrawingAspect

      CLASSES_TO_EXTEND = [Animation, Button, KeyListener]

      class << self
        attr_reader :app

        def redraws_for(swt_app)
          @app = swt_app
          extend_needed_classes
          add_redraws
        end

        private
        def extend_needed_classes
          CLASSES_TO_EXTEND.each { |klass| klass.extend AfterDo }
        end

        # TODO when to redrawn, when to just flush? figure out differences...
        def add_redraws
          Animation.after :eval_block do app.real.redraw end
          Button.after :eval_block do app.real.redraw end
          KeyListener.after :eval_block do app.flush end
        end
      end
    end
  end
end