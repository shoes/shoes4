# frozen_string_literal: true

class Shoes
  class Shape < Common::ArtElement
    attr_reader :blk, :x, :y, :left_bound, :top_bound, :right_bound, :bottom_bound

    style_with :art_styles, :center, :common_styles, :dimensions
    STYLES = { fill: Shoes::COLORS[:black] }.freeze

    def initialize(*args)
      @bottom_bound = nil
      @left_bound = nil
      @right_bound = nil
      @top_bound = nil
      @x = nil
      @y = nil
      super
    end

    def create_dimensions(left, top)
      left ||= @style[:left] || 0
      top  ||= @style[:top] || 0

      @dimensions = AbsoluteDimensions.new left, top
    end

    def handle_block(blk)
      # Will register click from styles if present, but blk is for drawing!
      register_click

      @blk = blk
    end

    def after_initialize(*_)
      @before_drawing = true
      @app.eval_with_additional_context self, &@blk

      # If we haven't drawn enough to get our bounds, default them out
      update_bounds([0], [0]) if @left_bound.nil?
    end

    def width
      @app.width
    end

    def height
      @app.height
    end

    def element_width
      return super unless @right_bound && @left_bound
      @right_bound - @left_bound
    end

    def element_height
      return super unless @bottom_bound && @top_bound
      @bottom_bound - @top_bound
    end

    def fixed_height?
      false
    end

    def redraw_left
      return 0 unless @left_bound
      @left_bound - strokewidth.to_i
    end

    def redraw_top
      return 0 unless @top_bound
      @top_bound - strokewidth.to_i
    end

    def redraw_width
      return 0 unless element_width
      element_width + 2 * strokewidth.to_i
    end

    def redraw_height
      return 0 unless element_height
      element_height + 2 * strokewidth.to_i
    end

    # Moves the shape
    #
    # @param [Integer] left The new left value
    # @param [Integer] top The new top value
    # @return [Shoes::Shape] This shape
    def move(left, top)
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
      @x = x
      @y = y
      @gui.line_to(x, y)
      self
    end

    # Moves the drawing "pen" to the given point
    #
    # @param [Integer] x The new point's x-value
    # @param [Integer] y The new point's y-value
    # @return [Shoes::Shape] self This shape
    def move_to(x, y)
      @x = x
      @y = y
      @gui.move_to(x, y)
      self
    end

    # Draws a curve
    #
    # @param [Integer] cx1 The first control point's x-value
    # @param [Integer] cy1 The first control point's y-value
    # @param [Integer] cx2 The second control point's x-value
    # @param [Integer] cy2 The second control point's y-value
    # @param [Integer] x The end point's x-value
    # @param [Integer] y The end point's y-value
    # @return [Shoes::Shape] This shape
    def curve_to(cx1, cy1, cx2, cy2, x, y)
      update_bounds([@x, cx1, cx2, x], [@y, cy1, cy2, y])
      @x = x
      @y = y
      @gui.curve_to(cx1, cy1, cx2, cy2, x, y)
      self
    end

    # Draws an arc
    #
    # @param [Integer] x The left position
    # @param [Integer] y The top position
    # @param [Integer] width The width of the arc
    # @param [Integer] height The height of the arc
    # @param [Integer] start_angle The start angle
    # @param [Integer] arc_angle The angular extent of the arc, relative to the start angle
    # @return [Shoes::Shape] This shape
    def arc_to(x, y, width, height, start_angle, arc_angle)
      update_bounds_rect(x - width / 2, y - height / 2, x + width / 2, y + height / 2)
      @x = x
      @y = y
      @gui.arc_to(x, y, width, height, start_angle, arc_angle)
      self
    end

    # Determines if a given point is in the boundary of the shape. Given the
    # many possibilities of what a shape could contain, this just checks the
    # outer bounding box of the shape, nothing more sophisticated.
    def in_bounds?(x, y)
      (@left_bound..@right_bound).cover?(x) &&
        (@top_bound..@bottom_bound).cover?(y)
    end

    private

    # Updates the bounds of this shape to include the rectangle described by
    # (x1, y1) and (x2, y2)
    #
    # @param [Integer] x1 The x-value of the first coordinate
    # @param [Integer] y1 The y-value of the first coordinate
    # @param [Integer] x2 The x-value of the second coordinate
    # @param [Integer] y2 The y-value of the second coordinate
    # @return nil
    def update_bounds_rect(x1, y1, x2, y2)
      update_bounds([x1, x2], [y1, y2])
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
      @left_bound = calculate_primary_dimension_value @left_bound, all_xs
      @top_bound = calculate_primary_dimension_value @top_bound, all_ys
      @right_bound = calculate_secondary_dimension_value @right_bound, all_xs
      @bottom_bound = calculate_secondary_dimension_value @bottom_bound, all_ys
      @before_drawing = false
      nil
    end

    def all_x_values(xs)
      all_values xs, @x, @left_bound, @right_bound
    end

    def all_y_values(ys)
      all_values ys, @y, @top_bound, @bottom_bound
    end

    def all_values(values, current, min, max)
      additional = @before_drawing ? [current] : [current, min, max]
      (values + additional).map(&:to_i)
    end

    def calculate_primary_dimension_value(current, new)
      new_min = Array(new).min
      return new_min if @before_drawing || new_min < current
      current
    end

    def calculate_secondary_dimension_value(current, new)
      new_max = Array(new).max
      return new_max if @before_drawing || new_max > current
      current
    end
  end
end
