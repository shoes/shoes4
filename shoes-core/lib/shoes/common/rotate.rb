# frozen_string_literal: true

class Shoes
  module Common
    module Rotate
      def needs_rotate?
        rotate && rotate.nonzero?
      end
    end
  end
end
