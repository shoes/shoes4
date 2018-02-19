# frozen_string_literal: true

class Shoes
  module DSL
    # DSL methods for drawing in Shoes applications.
    #
    # @see Shoes::DSL
    module Art
      # Creates an arrow.
      # Params are optional and may be passed by name in opts hash instead.
      #
      # @overload arrow(left = 0, top = 0, width = 0, opts)
      #   @param [Integer] left the x-coordinate of the element center
      #   @param [Integer] top the y-coordinate of the element center
      #   @param [Integer] width the width of the arrow
      #   @param [Hash] opts
      #   @option opts [Integer] rotate (false)
      #   @return [Shoes::Arrow]
      def arrow(*args, &blk)
        opts = style_normalizer.normalize pop_style(args)

        left, top, width, *leftovers = args

        message = <<~EOS
          Too many arguments. Must be one of:
            - arrow(left, top, width, [opts])
            - arrow(left, top, [opts])
            - arrow(left, [opts])
            - arrow([opts])
EOS
        raise ArgumentError, message if leftovers.any?

        create Shoes::Arrow, left, top, width, opts, blk
      end

      # Creates an arc.
      # Params are optional and may be passed by name in opts hash instead.
      #
      # @overload arc(left = 0, top = 0, width = 0, height = 0, angle1 = 0, angle2 = 0, opts)
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Integer] width width of the arc's ellipse
      #   @param [Integer] height height of the arc's ellipse
      #   @param [Float] angle1 angle in radians marking the beginning of the arc segment
      #   @param [Float] angle2 angle in radians marking the end of the arc segment
      #   @param [Hash] opts
      #   @option opts [Boolean] wedge (false)
      #   @option opts [Boolean] center (false) is (left, top) the center of the rectangle?
      #   @return [Shoes::Arc]
      def arc(*args, &blk)
        opts = style_normalizer.normalize pop_style(args)

        left, top, width, height, angle1, angle2, *leftovers = args

        message = <<~EOS
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

      # Draws a line from point A (x1,y1) to point B (x2,y2).
      # Params are optional and may be passed by name in opts hash instead.
      #
      # @overload line(x1 = 0, y1 = 0, x2 = 0, y2 = 0, opts)
      #   @param [Integer] x1 The x-value of point A
      #   @param [Integer] y1 The y-value of point A
      #   @param [Integer] x2 The x-value of point B
      #   @param [Integer] y2 The y-value of point B
      #   @param [Hash] opts
      #   @return [Shoes::Line]
      def line(*args, &blk)
        opts = style_normalizer.normalize pop_style(args)

        x1, y1, x2, y2, *leftovers = args

        message = <<~EOS
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

      # Creates an oval.
      # Params are optional and may be passed by name in opts hash instead.
      #
      # @overload oval(left = 0, top = 0, width = 0, height = width, opts)
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Integer] width the width
      #   @param [Integer] height the height
      #   @param [Hash] opts
      #   @option opts [Boolean] center (false) is (left, top) the center of the oval
      #   @return [Shoes::Oval]
      def oval(*args, &blk)
        opts = style_normalizer.normalize pop_style(args)

        left, top, width, height, *leftovers = args

        message = <<~EOS
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

      # Creates a rectangle.
      # Params are optional and may be passed by name in opts hash instead.
      #
      # @overload rect(left = 0, top = 0, width = 0, height = height, rounded = 0, opts)
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Integer] width the width
      #   @param [Integer] height the height
      #   @param [Integer] rounded curve amount to apply to corners
      #   @param [Hash] opts
      #   @option opts [Boolean] center (false) is (left, top) the center of the rectangle?
      #   @return [Shoes::Rect]
      def rect(*args, &blk)
        opts = style_normalizer.normalize pop_style(args)

        left, top, width, height, curve, *leftovers = args
        opts[:curve] = curve if curve

        message = <<~EOS
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

      # Creates a star.
      # Params are optional and may be passed by name in opts hash instead.
      #
      # @overload star(left = 0, top = 0, points = 10, outer = 100, inner = 50, opts)
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Integer] points count of points on the star
      #   @param [Integer] outer outer radius of star
      #   @param [Integer] inner inner radius of star
      #   @param [Hash] opts
      #   @return [Shoes::Star]
      def star(*args, &blk)
        styles = style_normalizer.normalize pop_style(args)

        left, top, points, outer, inner, *leftovers = args

        message = <<~EOS
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

      # Creates an arbitrary shape.
      # Params are optional and may be passed by name in opts hash instead.
      #
      # @overload shape(left = 0, top = 0, styles, &block)
      #   @param [Integer] left the x-coordinate of the top-left corner
      #   @param [Integer] top the y-coordinate of the top-left corner
      #   @param [Proc] blk code describing how to draw the shape
      #   @param [Hash] opts
      #   @return [Shoes::Shape]
      def shape(*args, &blk)
        opts = style_normalizer.normalize pop_style(args)

        left, top, *leftovers = args

        message = <<~EOS
          Wrong number of arguments. Must be one of:
            - shape(left, top, [opts])
            - shape(left, [opts])
            - shape([opts])
EOS

        raise ArgumentError, message if leftovers.any?

        create Shoes::Shape, left, top, opts, blk
      end

      # Raises kinder error message for method Shoes 4 doesn't support.
      # See https://github.com/shoes/shoes4/issues/527.
      #
      # @deprecated
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
