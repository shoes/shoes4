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
        init_with_arguments(left_or_hash, top, width, height, opts)
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
      value = @left || 0
      value = adjust_left_for_center value if left_top_as_center?
      value
    end

    def top
      value = @top || 0
      value = adjust_top_for_center(value) if left_top_as_center?
      value
    end

    def width
      calculate_dimension(:width)
    end

    def height
      calculate_dimension(:height)
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

    def init_with_hash(dimensions_hash)
      self.left   = dimensions_hash.fetch(:left, nil)
      self.top    = dimensions_hash.fetch(:top, nil)
      self.width  = dimensions_hash.fetch(:width, nil)
      self.height = dimensions_hash.fetch(:height, nil)
      general_options dimensions_hash
    end

    def init_with_arguments(left, top, width, height, opts)
      self.left   = left
      self.top    = top
      self.width  = width
      self.height = height
      general_options opts
    end

    def general_options(opts)
      @left_top_as_center = opts.fetch(:center, false)
    end

    def calculate_dimension(name)
      result = instance_variable_get("@#{name}".to_sym)
      if @parent
        result = calculate_relative(name, result) if is_relative?(result)
        result = calculate_negative(name, result) if is_negative?(result)
      end
      result
    end

    def is_relative?(result)
      result.is_a?(Float)
    end

    def calculate_relative(name, result)
      (result * @parent.send(name)).to_i
    end

    def is_negative?(result)
      result && result < 0
    end

    def calculate_negative(name, result)
      @parent.send(name) + result
    end

    def left_top_as_center?
      @left_top_as_center
    end

    def adjust_left_for_center(left_value)
      my_width = width
      if my_width && my_width > 0
        left_value - my_width / 2
      else
        left_value
      end
    end

    def adjust_top_for_center(top_value)
      my_height = height
      if my_height && my_height > 0
        top_value - my_height / 2
      else
        top_value
      end
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
