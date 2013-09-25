class Shoes
  class Dimensions
    attr_accessor :left, :top, :width, :height

    def initialize(left = 0, top = 0, width = nil, height = nil, parent = nil)
      if hash_as_argument?(left)
        init_with_hash(left)
      else
        init_with_arguments(left, top, width, height, parent)
      end
      convert_percentage_dimensions_to_pixel
    end

    def right
      left + (width || 0)
    end

    def bottom
      top + (height || 0)
    end

    def in_bounds?(x, y)
      left <= x and x <= right and top <= y and y <= bottom
    end

    private
    def hash_as_argument?(left)
      left.respond_to? :fetch
    end

    def init_with_hash(dimensions_hash)
      @left   = dimensions_hash.fetch(:left, 0)
      @top    = dimensions_hash.fetch(:top, 0)
      @width  = dimensions_hash.fetch(:width, nil)
      @height = dimensions_hash.fetch(:height, nil)
      @parent = dimensions_hash.fetch(:parent, nil)
    end

    def init_with_arguments(left, top, width, height, parent = nil)
      @left   = left
      @top    = top
      @width  = width
      @height = height
      @parent = parent
    end

    def convert_percentage_dimensions_to_pixel
      @width = (@width * @parent.width).to_i if @width.is_a?(Float) && @parent
      @height = (@height * @parent.height).to_i if @height.is_a?(Float) && @parent
    end
  end

  # depends on a #dimensions method being present that returns a Dimensions object
  module DimensionsDelegations
    extend Forwardable

    DELEGATED_METHODS = [:left, :top, :width, :height, :right, :bottom,
                         :in_bounds?, :left=, :top=, :width=, :height=]

    def_delegators :dimensions, *DELEGATED_METHODS
  end

  # depends on a #dsl method to forward to (e.g. for backend objects)
  module BackendDimensionsDelegations
    extend Forwardable

    def_delegators :dsl, *DimensionsDelegations::DELEGATED_METHODS
  end
end
