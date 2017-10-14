# frozen_string_literal: true

class Shoes
  module Common
    module Attachable
      def attached_to
        target = style[:attach]
        target = @app.top_slot if target == Shoes::Window
        target
      end
    end
  end
end
