class Shoes
  module Swt

    module RedrawingAspect
      class << self
        attr_reader :app

        def redraws_for(swt_app)
          @app = swt_app
          extend_needed_classes
          add_redraws
        end

        private
        def extend_needed_classes
          Animation.extend AfterDo
        end

        def add_redraws
          Animation.after :eval_block do app.real.redraw end
        end
      end
    end
  end
end