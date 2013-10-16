class Shoes
  class Dimensions
    attr_accessor :absolute_left, :absolute_top
    attr_writer   :width, :height

    def initialize(parent, left_or_hash = nil, top = nil, width = nil,
                   height = nil, opts = {})
      @parent = parent
      if hash_as_argument?(left_or_hash)
        init_with_hash(left_or_hash)
      else
        init_with_arguments(left_or_hash, top, width, height, parent, opts)
      end
    end

    def left=(value)
      return if value.nil?
      @left = value
      @absolute_x_position = true
    end

    def top=(value)
      return if value.nil?
      @top = value
      @absolute_y_position = true
    end

    def left
      @left || 0
    end

    def top
      @top || 0
    end

    def width
      if @width.is_a?(Float) && @parent
        (@width * @parent.width).to_i
      else
        @width
      end
    end

    def height
      if @height.is_a?(Float) && @parent
        (@height * @parent.height).to_i
      else
        @height
      end
    end

    def absolute_x_position?
      @absolute_x_position
    end

    def absolute_y_position?
      @absolute_y_position
    end

    def absolutely_positioned?
      absolute_x_position? || absolute_y_position?
    end

    def right
      left + (width || 0)
    end

    def bottom
      top + (height || 0)
    end

    def absolute_right
      absolute_left + (width || 0)
    end

    def absolute_bottom
      absolute_top + (height || 0)
    end

    def in_bounds?(x, y)
      left <= x and x <= right and top <= y and y <= bottom
    end

    private
    def hash_as_argument?(left)
      left.respond_to? :fetch
    end

    def adjust_for_left_top_as_center(opts)
      if opts.fetch(:center, false)
        @left -= @width / 2 if @width && @width > 0
        @top -= @height / 2 if @height && @height > 0
      end
    end

    def init_with_hash(dimensions_hash)
      self.left   = dimensions_hash.fetch(:left, nil)
      self.top    = dimensions_hash.fetch(:top, nil)
      self.width  = dimensions_hash.fetch(:width, nil)
      self.height = dimensions_hash.fetch(:height, nil)
      adjust_for_left_top_as_center(dimensions_hash)
    end

    def init_with_arguments(left, top, width, height, parent, opts)
      self.left   = left
      self.top    = top
      self.width  = width
      self.height = height
      adjust_for_left_top_as_center(opts)
    end
  end

  # for objects that are always absolutely positioned e.g. left == absolute_left
  class AbsoluteDimensions < Dimensions

    def initialize(*args)
      super(nil, *args)
    end

    def absolute_left
      left
    end

    def absolute_top
      top
    end
  end

  # depends on a #dimensions method being present that returns a Dimensions object
  module DimensionsDelegations
    extend Forwardable

    DELEGATED_METHODS = Dimensions.public_instance_methods false

    def_delegators :dimensions, *DELEGATED_METHODS
  end

  # depends on a #dsl method to forward to (e.g. for backend objects)
  module BackendDimensionsDelegations
    extend Forwardable

    def_delegators :dsl, *DimensionsDelegations::DELEGATED_METHODS
  end
end
