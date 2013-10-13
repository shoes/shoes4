class Shoes
  class Star
    include CommonMethods
    include Common::Fill
    include Common::Stroke
    include Common::Style
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :app, :gui, :angle, :dimensions, :outer, :inner, :points

    def initialize(app, left, top, points, outer, inner, opts = {}, &blk)
      @app = app

      # Careful not to turn Fixnum to Float, lest Dimensions make you relative!
      width = outer*2

      # Ignore calculated height on Dimensions--will force to match width
      @dimensions = AbsoluteDimensions.new app, left, top, width, 0
      @dimensions.height = @dimensions.width

      # Calculate the inner dimensions, which might be relative too
      inner_dimensions = AbsoluteDimensions.new app, 0, 0, inner*2, 0

      # Get actual outer/inner from the dimension to handle relative values
      @outer = @dimensions.width / 2
      @inner = inner_dimensions.width / 2

      @points = points
      @angle = opts[:angle] || 0
      @style = Shoes::Common::Fill::DEFAULTS.merge(Shoes::Common::Stroke::DEFAULTS).merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1
      @app.unslotted_elements << self

      @gui = Shoes.backend_for(self, &blk)

      clickable_options(opts)
    end

    def in_bounds?(x, y)
      dx = width / 2.0
      dy = height / 2.0
      left - dx <= x and x <= right - dx and top - dy <= y and y <= bottom - dy
    end

  end
end
