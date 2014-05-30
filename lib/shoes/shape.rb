class Shoes
  class Shape
    include Shoes::CommonMethods
    include Shoes::Common::Fill
    include Shoes::Common::Stroke
    include Shoes::Common::Style
    include Shoes::Common::Clickable
    include DimensionsDelegations

    # Creates a new Shoes::Shape
    #
    def initialize(app, parent, opts = {}, blk = nil)
      @app = app
      @dimensions = AbsoluteDimensions.new opts
      @style = Shoes::Common::Fill::DEFAULTS.merge(Shoes::Common::Stroke::DEFAULTS).merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1
      @blk = blk
      @parent = parent

      # True until we've asked the pen to draw
      @before_drawing = true

      @parent.add_child self

      # GUI
      @gui = Shoes.backend_for(self, @style)

      instance_eval &@blk unless @blk.nil?

      clickable_options(opts)
    end

    attr_reader :app, :blk, :dimensions, :gui, :hidden
    attr_reader :x, :y

    def width
      @app.width
    end

    def height
      @app.height
    end

    def needs_to_be_positioned?
      true
    end

    def takes_up_space?
      true
    end

    def positioned?
      absolute_left && absolute_top
    end

    # Moves the shape
    #
    # @param [Integer] left The new left value
    # @param [Integer] top The new top value
    # @return [Shoes::Shape] This shape
    def move(left, top)
      right += offset(self.left, left) if right
      bottom += offset(self.top, top) if bottom
      self.left = left
      self.top = top
      @gui.update_position
      self
    end

    # Draws a line from the current position to the given point
    #
    # @param [Integer] x The new point's x-value
    # @param [Integer] y The new point's y-value
    # @return [Shoes::Shape] This shape
    def line_to(x, y)
      update_bounds_rect(@x, @y, x, y)
      @x, @y = x, y
      @gui.line_to(x, y)
      self
    end

    # Moves the drawing "pen" to the given point
    #
    # @param [Integer] x The new point's x-value
    # @param [Integer] y The new point's y-value
    # @return [Shoes::Shape] self This shape
    def move_to(x, y)
      @x, @y = x, y
      @gui.move_to(x, y)
      self
    end

    def quad_to *args
      @gui.quad_to *args
      self
    end

    def curve_to(cx1, cy1, cx2, cy2, x, y)
      update_bounds([@x, cx1, cx2, x], [@y, cy1, cy2, y])
      @gui.curve_to(cx1, cy1, cx2, cy2, x, y)
      self
    end

    def arc(x, y, width, height, start_angle, arc_angle)
      @x, @y = x, y
      update_bounds_rect(x-width/2, y-height/2, x+width/2, y+height/2)
      @gui.arc(x, y, width, height, start_angle, arc_angle)
      self
    end

    private
    # Gives the relative offset of the new position from original position.
    # This calculation is for a single coordinate value, e.g. an x or a y.
    #
    # @param [Integer] original The original position
    # @param [Integer] new The new position
    # @return [Integer] A value that should be added to the current position in order to
    #   move to the new position.
    def offset(original, new)
      return 0 unless original && new
      relative = (new - original).abs
      relative = -relative if new < original
      relative
    end

    # Updates the bounds of this shape to include the rectangle described by
    # (x1, y1) and (x2, y2)
    #
    # @param [Integer] x1 The x-value of the first coordinate
    # @param [Integer] y1 The y-value of the first coordinate
    # @param [Integer] x2 The x-value of the second coordinate
    # @param [Integer] y2 The y-value of the second coordinate
    # @return nil
    def update_bounds_rect(x1, y1, x2, y2)
      update_bounds( [x1, x2], [y1, y2] )
    end

    # Updates the bounds of this shape to the rectangle covering all
    # the given coordinates.
    #
    # @param [Array<Integer>] xs Array of X coordinates
    # @param [Array<Integer>] ys Array of Y coordinates
    # @return nil
    def update_bounds(xs, ys)
      all_xs = all_x_values(xs)
      all_ys = all_y_values(ys)
      x_min = all_xs.min
      x_max = all_xs.max
      y_min = all_ys.min
      y_max = all_ys.max
      self.left = calculate_primary_dimension_value self.left, x_min
      self.top = calculate_primary_dimension_value self.top, y_min
      self.right = calculate_secondary_dimension_value self.right, x_max
      self.bottom = calculate_secondary_dimension_value self.top, y_max
      @before_drawing = false
      nil
    end

    def all_x_values(xs)
      all_values xs, @x, self.left, self.right
    end

    def all_y_values(ys)
      all_values ys, @y, self.top, self.bottom
    end

    def all_values(values, current, min, max)
      additional = @before_drawing ? [current] : [current, min, max]
      (values + additional).map &:to_i
    end

    def calculate_primary_dimension_value(current, new)
      return new if @before_drawing
      [current, new].min
    end

    def calculate_secondary_dimension_value(current, new)
      return new if @before_drawing
      [current, new].max
    end
  end
end
