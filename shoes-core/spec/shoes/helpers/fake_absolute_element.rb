# frozen_string_literal: true

class Shoes
  class FakeAbsoluteElement < FakeElement
    include Shoes::DimensionsDelegations

    attr_accessor :dimensions

    def initialize
      @dimensions = AbsoluteDimensions.new 0, 0, 100, 100
    end
  end
end
