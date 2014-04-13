class Shoes
  class Shape
    include Shoes::CommonMethods
    include Shoes::Common::Fill
    include Shoes::Common::Stroke
    include Shoes::Common::Style
    include Shoes::Common::Clickable

    # Creates a new Shoes::Shape
    #
    def initialize(app, opts = {}, blk = nil)
      @app = app
      @style = Shoes::Common::Fill::DEFAULTS.merge(Shoes::Common::Stroke::DEFAULTS).merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1
      @blk = blk

      @displace_left = 0
      @displace_top  = 0

      # GUI
      @gui = Shoes.backend_for(self, @style)

      instance_eval &@blk unless @blk.nil?

      clickable_options(opts)
    end

    attr_reader :app, :blk, :gui, :hidden
    attr_reader :x, :y
    attr_accessor :displace_left, :displace_top

    def left
      @left || 0
    end

    def top
      @top || 0
    end

    alias_method :absolute_left, :left
    alias_method :absolute_top, :top
    alias_method :element_left, :left
    alias_method :element_top, :top


    def right
      @right || left
    end

    def bottom
      @bottom || top
    end

    def width
      @app.width
    end

    def height
      @app.height
    end

    alias_method :element_width, :width
    alias_method :element_height, :height

    def needs_to_be_positioned?
      true
    end

    def takes_up_space?
      true
    end

    # Moves the shape
    #
    # @param [Integer] left The new left value
    # @param [Integer] top The new top value
    # @return [Shoes::Shape] This shape
    def move(left, top)
      @right += offset(@left, left) if @right
      @bottom += offset(@top, top) if @bottom
      @left = left
      @top = top
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
      x_min = xs.min
      x_max = xs.max
      y_min = ys.min
      y_max = ys.max
      @left = x_min unless @left && x_min > @left
      @top = y_min unless @top && y_min > @top
      @right = x_max unless @right && x_max < @right
      @bottom = y_max unless @bottom && y_max < @bottom
      nil
    end
  end
end
