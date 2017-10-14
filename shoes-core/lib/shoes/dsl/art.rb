# frozen_string_literal: true

class Shoes
  module DSL
    module Art
      # Creates an arrow
      #
      # @overload arrow(left, top, width, opts)
      #   Creates an arrow centered at (left, top)
      #   @param [Integer] left the x-coordinate of the element center
      #   @param [Integer] top the y-coordinate of the element center
      #   @param [Integer] width the width of the arrow
      #   @param [Hash] opts Arrow style options
      #   @option opts [Integer] rotate (false)
      # @overload arrow(opts)
      #   Creates an arrow using values from the opts Hash.
      #   @param [Hash] opts
      #   @option styles [Integer] left (0) the x-coordinate of the top-left corner
      #   @option styles [Integer] top (0) the y-coordinate of the top-left corner
      #   @option styles [Integer] width (0) the width
      #   @option styles [Integer] rotate (false)
      def arrow(*args, &blk)
        opts = style_normalizer.normalize pop_style(args)

        left, top, width, *leftovers = args

        message = <<EOS
Too many arguments. Must be one of:
  - arrow(left, top, width, [opts])
  - arrow(left, top, [opts])
  - arrow(left, [opts])
  - arrow([opts])
EOS
        raise ArgumentError, message if leftovers.any?

        create Shoes::Arrow, left, top, width, opts, blk
      end

      # Creates an arc at (left, top)
      #
      # @param [Integer] left the x-coordinate of the top-left corner
      # @param [Integer] top the y-coordinate of the top-left corner
      # @param [Integer] width width of the arc's ellipse
      # @param [Integer] height height of the arc's ellipse
      # @param [Float] angle1 angle in radians marking the beginning of the arc segment
      # @param [Float] angle2 angle in radians marking the end of the arc segment
      # @param [Hash] opts Arc style options
      # @option opts [Boolean] wedge (false)
      # @option opts [Boolean] center (false) is (left, top) the center of the rectangle?
      def arc(*args, &blk)
        opts = style_normalizer.normalize pop_style(args)

        left, top, width, height, angle1, angle2, *leftovers = args

        message = <<EOS
Too many arguments. Must be one of:
  - arc(left, top, width, height, angle1, angle2, [opts])
  - arc(left, top, width, height, angle1, [opts])
  - arc(left, top, width, height, [opts])
  - arc(left, top, width, [opts])
  - arc(left, top, [opts])
  - arc(left, [opts])
  - arc([opts])
EOS
        raise ArgumentError, message if leftovers.any?

        create Shoes::Arc, left, top, width, height, angle1, angle2, opts, blk
      end

      # Draws a line from point A (x1,y1) to point B (x2,y2)
      #
      # @param [Integer] x1 The x-value of point A
      # @param [Integer] y1 The y-value of point A
      # @param [Integer] x2 The x-value of point B
      # @param [Integer] y2 The y-value of point B
      # @param [Hash] opts Style options
      def line(*args, &blk)
        opts = style_normalizer.normalize pop_style(args)

        x1, y1, x2, y2, *leftovers = args

        message = <<EOS
Too many arguments. Must be one of:
  - line(x1, y1, x2, y2, [opts])
  - line(x1, y1, x2, [opts])
  - line(x1, y1, [opts])
  - line(x1, [opts])
  - line([opts])
EOS
        raise ArgumentError, message if leftovers.any?

        create Shoes::Line, x1, y1, x2, y2, opts, blk
      end

      # Creates an oval at (left, top)
      #
      # @overload oval(left, top, diameter)
      #   Creates a circle at (left, top), with the given diameter
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Integer] diameter the diameter
      # @overload oval(left, top, width, height)
      #   Creates an oval at (left, top), with the given width and height
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Integer] width the width
      #   @param [Integer] height the height
      # @overload oval(styles)
      #   Creates an oval using values from the styles Hash.
      #   @param [Hash] styles
      #   @option styles [Integer] left (0) the x-coordinate of the top-left corner
      #   @option styles [Integer] top (0) the y-coordinate of the top-left corner
      #   @option styles [Integer] width (0) the width
      #   @option styles [Integer] height (0) the height
      #   @option styles [Integer] top (0) the y-coordinate of the top-left corner
      #   @option styles [Boolean] center (false) is (left, top) the center of the oval
      def oval(*args, &blk)
        opts = style_normalizer.normalize pop_style(args)

        left, top, width, height, *leftovers = args

        message = <<EOS
Wrong number of arguments. Must be one of:
  - oval(left, top, width, height, [opts])
  - oval(left, top, diameter, [opts])
  - oval(left, top, [opts])
  - oval(left, [opts])
  - oval(styles)
EOS
        raise ArgumentError, message if leftovers.any?

        create Shoes::Oval, left, top, width, height, opts, blk
      end

      # Creates a rectangle
      #
      # @overload rect(left, top, side, styles)
      #   Creates a square at (left, top), with sides of the given length
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Integer] side the length of a side
      # @overload rect(left, top, width, height, rounded = 0, styles)
      #   Creates a rectangle at (left, top), with the given width and height
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Integer] width the width
      #   @param [Integer] height the height
      # @overload rect(styles)
      #   Creates a rectangle using values from the styles Hash.
      #   @param [Hash] styles
      #   @option styles [Integer] left (0) the x-coordinate of the top-left corner
      #   @option styles [Integer] top (0) the y-coordinate of the top-left corner
      #   @option styles [Integer] width (0) the width
      #   @option styles [Integer] height (0) the height
      #   @option styles [Integer] top (0) the y-coordinate of the top-left corner
      #   @option styles [Boolean] center (false) is (left, top) the center of the rectangle?
      def rect(*args, &blk)
        opts = style_normalizer.normalize pop_style(args)

        left, top, width, height, curve, *leftovers = args
        opts[:curve] = curve if curve

        message = <<EOS
Wrong number of arguments. Must be one of:
  - rect(left, top, width, height, curve, [opts])
  - rect(left, top, width, height, [opts])
  - rect(left, top, side, [opts])
  - rect(left, top, [opts])
  - rect(left, [opts])
  - rect(styles)
EOS

        raise ArgumentError, message if leftovers.any?

        create Shoes::Rect, left, top, width, height, style.merge(opts), blk
      end

      # Creates a new Shoes::Star object
      #
      # @overload star(left, top, styles, &block)
      #   Creates a star at (left, top) with the given style
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Hash] styles optional, additional styling for the element
      # @overload star(left, top, points, styles, &block)
      #   Creates a star at (left, top) with the given style
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Integer] points count of points on the star
      #   @param [Hash] styles optional, additional styling for the element
      # @overload star(left, top, points, outer, styles, &block)
      #   Creates a star at (left, top) with the given style
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Integer] points count of points on the star
      #   @param [Integer] outer outer radius of star
      #   @param [Hash] styles optional, additional styling for the element
      # @overload star(left, top, points, outer, inner, styles, &block)
      #   Creates a star at (left, top) with the given style
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Integer] points count of points on the star
      #   @param [Integer] outer outer radius of star
      #   @param [Integer] inner inner radius of star
      #   @param [Hash] styles optional, additional styling for the element
      def star(*args, &blk)
        styles = style_normalizer.normalize pop_style(args)

        left, top, points, outer, inner, *leftovers = args

        message = <<EOS
Wrong number of arguments. Must be one of:
  - star([styles])
  - star(left, [styles])
  - star(left, top, [styles])
  - star(left, top, points, [styles])
  - star(left, top, points, outer, [styles])
  - star(left, top, points, outer, inner, [styles])
EOS
        raise ArgumentError, message if leftovers.any?

        create Shoes::Star, left, top, points, outer, inner, styles, blk
      end

      # Creates a new Shoes::Shape object
      #
      # @overload shape(left, top, styles, &block)
      #   Creates a shape at (left, top) with the given style
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      # @overload shape(left, top)
      #   Creates a shape at (left, top, &block)
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      # @overload shape(styles, &block)
      #   Creates a shape at (0, 0)
      #   @option styles [Integer] left (0) the x-coordinate of the top-left corner
      #   @option styles [Integer] top (0) the y-coordinate of the top-left corner
      def shape(*args, &blk)
        opts = style_normalizer.normalize pop_style(args)

        left, top, *leftovers = args

        message = <<EOS
Wrong number of arguments. Must be one of:
  - shape(left, top, [opts])
  - shape(left, [opts])
  - shape([opts])
EOS

        raise ArgumentError, message if leftovers.any?

        create Shoes::Shape, left, top, opts, blk
      end

      def mask(*_)
        raise Shoes::NotImplementedError,
              <<~EOS
                Sorry mask is not supported currently in Shoes 4!
                Check out github issue #527 for any changes/updates or if you want to help :)
              EOS
      end
    end
  end
end
