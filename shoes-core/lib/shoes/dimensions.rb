# frozen_string_literal: true

class Shoes
  # Dimensions is a central class that most Shoes classes use to represent their
  # dimensions, e.g. where they are and how much space they are taking up there.
  # All the different position types might be confusing. So here is a little list:
  #
  # = Position (left, top, right, bottom)
  #
  # *plain* (+left+, +top+, +right+, +bottom+): An offset relative to
  # the parent (parents mostly are slots e.g.  flows/stacks), e.g it isn't
  # fully positioned/doesn't flow anymore when set
  #
  # *absolute_** (+absolute_left+, +absolute_top+, +absolute_right+,
  # +absolute_bottom+): The absolute position an element begins positioning
  # from in the app (in +slot.rb+). Margins are not included in absolute
  # position values--that's the main difference between +absolute+ and
  # +element+ values.
  #
  # *element_** (+element_left+, +element_top+, +element_right+,
  # +element_bottom+): Derived from +absolute_+* but shows the real position
  # of the object, e.g. it adds the margins to +absolute_+* (mostly used by
  # backend drawing code).
  #
  # = Space Taken Up (width/height)
  #
  # *plain* (+width+, +height+): The whole space taken up by this
  # element with margins and everything. Used for positioning/by the user.
  #
  # *element_** (+element_width+, +element_height+): Just the space
  # taken up by the element itself without margins. Used by drawing.
  #
  # Note that this is NOT how margins work in the CSS box model. We diverge for
  # reasons mentioned
  # {here}[https://github.com/shoes/shoes4/pull/467#issuecomment-27655355]
  class Dimensions
    include Common::Inspect

    attr_reader :parent, :x_dimension, :y_dimension
    protected :parent # we shall not mess with parent,see #495

    # In case you wonder about the -1... it is used to adjust the right and
    # bottom values. Because right is not left + width but rather left + width
    # -1
    #
    # Let me give you an example:
    #
    # Say left is 20 and we have a width of 100 then the right must be 119,
    # because you have to take pixel number 20 into account so 20..119 is 100
    # while 20..120 is 101. E.g.: (20..119).size => 100
    #
    # @private
    PIXEL_COUNTING_ADJUSTMENT = -1

    def initialize(parent, left_or_hash = nil, top = nil, width = nil,
                   height = nil, opts = {})
      @parent = parent
      if hash_as_argument?(left_or_hash)
        init_with_hash(left_or_hash)
      else
        init_with_arguments(left_or_hash, top, width, height, opts)
      end
    end

    # Is this element absolutely positioned in the horizontal dimension
    def absolute_x_position?
      x_dimension.absolute_position?
    end

    # Is this element absolutely positioned in the vertical dimension
    def absolute_y_position?
      y_dimension.absolute_position?
    end

    # Is this element absolutely positioned in any dimension
    def absolutely_positioned?
      absolute_x_position? || absolute_y_position?
    end

    # Is this element's left positioned absolutely
    def absolute_left_position?
      @x_dimension.absolute_start_position?
    end

    # Is this element's right positioned absolutely
    def absolute_right_position?
      @x_dimension.absolute_end_position?
    end

    # Is this element's top positioned absolutely
    def absolute_top_position?
      @y_dimension.absolute_start_position?
    end

    # Is this element's bottom positioned absolutely
    def absolute_bottom_position?
      @y_dimension.absolute_end_position?
    end

    # Has this element been positioned by layout
    def positioned?
      x_dimension.positioned? && y_dimension.positioned?
    end

    # Is the given point within the bounds of this element
    #
    # @param [Fixnum] x Location the x dimension to check
    # @param [Fiynum] y Location the y dimension to check
    # @return [Boolean] true if point is within this element, false otherwise
    def in_bounds?(x, y)
      x_dimension.in_bounds?(x) && y_dimension.in_bounds?(y)
    end

    # Is another element fully contained within this element?
    #
    # @param [Shoes::Common::UIElement] other Element to check is contained
    def contains?(other)
      return false unless other.element_left && other.element_top &&
                          other.element_right && other.element_bottom

      element_left <= other.element_left &&
        element_right >= other.element_right &&
        element_top <= other.element_top &&
        element_bottom >= other.element_bottom
    end

    # Margins for the element
    #
    # @return [Array<Fixnum>] left, top, right and bottom margin as array
    def margin
      [margin_left, margin_top, margin_right, margin_bottom]
    end

    # Set margin value for element
    #
    # If a single value is passed, all margins are set to that value.
    #
    # If an array is passed, values from array are spread to left, top,
    # right and bottom in that order.
    #
    # @param [Fixnum, Array<Fixnum>] margin Value or array of values to set
    # margin to
    def margin=(margin)
      margin = [margin, margin, margin, margin] unless margin.is_a? Array
      self.margin_left, self.margin_top,
      self.margin_right, self.margin_bottom = margin
    end

    # Determines if this element participate in slot positioning
    #
    # @return [Boolean] Whether to position element during slot layout
    def needs_positioning?
      true
    end

    # Determines whether to advance current position during slot layout
    #
    # @return [Boolean] Whether to advance position after laying out this
    # element
    def takes_up_space?
      true
    end

    def width
      @x_dimension.extent
    end

    def width=(value)
      @x_dimension.extent = value
    end

    def height
      @y_dimension.extent
    end

    def height=(value)
      @y_dimension.extent = value
    end

    def left
      @x_dimension.start
    end

    def left=(value)
      @x_dimension.start = value
    end

    def right
      @x_dimension.end
    end

    def right=(value)
      @x_dimension.end = value
    end

    def top
      @y_dimension.start
    end

    def top=(value)
      @y_dimension.start = value
    end

    def bottom
      @y_dimension.end
    end

    def bottom=(value)
      @y_dimension.end = value
    end

    def element_height
      @y_dimension.element_extent
    end

    def element_height=(value)
      @y_dimension.element_extent = value
    end

    def element_width
      @x_dimension.element_extent
    end

    def element_width=(value)
      @x_dimension.element_extent = value
    end

    def element_left
      @x_dimension.element_start
    end

    def element_right
      @x_dimension.element_end
    end

    def element_top
      @y_dimension.element_start
    end

    def element_bottom
      @y_dimension.element_end
    end

    def margin_left
      @x_dimension.margin_start
    end

    def margin_left=(value)
      @x_dimension.margin_start = value
    end

    def margin_right
      @x_dimension.margin_end
    end

    def margin_right=(value)
      @x_dimension.margin_end = value
    end

    def margin_top
      @y_dimension.margin_start
    end

    def margin_top=(value)
      @y_dimension.margin_start = value
    end

    def margin_bottom
      @y_dimension.margin_end
    end

    def margin_bottom=(value)
      @y_dimension.margin_end = value
    end

    def absolute_left
      @x_dimension.absolute_start
    end

    def absolute_left=(value)
      @x_dimension.absolute_start = value
    end

    def absolute_right
      @x_dimension.absolute_end
    end

    def absolute_top
      @y_dimension.absolute_start
    end

    def absolute_top=(value)
      @y_dimension.absolute_start = value
    end

    def absolute_bottom
      @y_dimension.absolute_end
    end

    def displace_left
      @x_dimension.displace_start
    end

    def displace_left=(value)
      @x_dimension.displace_start = value
    end

    def displace_top
      @y_dimension.displace_start
    end

    def displace_top=(value)
      @y_dimension.displace_start = value
    end

    private

    def inspect_details
      nothing = '_'
      " relative:#{Point.new left, top}->#{Point.new right, bottom}" \
        " absolute:#{Point.new absolute_left, absolute_top}->#{Point.new absolute_right, absolute_bottom}" \
        " #{width || nothing}x#{height || nothing}"
    end

    def hash_as_argument?(left)
      left.respond_to? :fetch
    end

    def init_with_hash(hash)
      init_with_arguments hash.fetch(:left, nil), hash.fetch(:top, nil),
                          hash.fetch(:width, nil), hash.fetch(:height, nil),
                          hash
    end

    def init_with_arguments(left, top, width, height, opts)
      @left_top_as_center = opts.fetch(:center, false)
      init_x_and_y_dimensions
      general_options opts # order important for redrawing
      self.displace_left = opts.fetch(:displace_left, nil)
      self.displace_top  = opts.fetch(:displace_top, nil)
      self.left          = left
      self.top           = top
      self.width         = width
      self.height        = height
    end

    def init_x_and_y_dimensions
      parent_x_dimension = @parent ? @parent.x_dimension : nil
      parent_y_dimension = @parent ? @parent.y_dimension : nil
      @x_dimension = Dimension.new parent_x_dimension, @left_top_as_center
      @y_dimension = Dimension.new parent_y_dimension, @left_top_as_center
    end

    def general_options(opts)
      self.right =  opts[:right]
      self.bottom = opts[:bottom]
      init_margins opts
    end

    def init_margins(opts)
      new_opts = opts.reject { |_k, v| v.nil? }
      self.margin        = new_opts[:margin]
      self.margin_left   = new_opts.fetch(:margin_left, margin_left)
      self.margin_top    = new_opts.fetch(:margin_top, margin_top)
      self.margin_right  = new_opts.fetch(:margin_right, margin_right)
      self.margin_bottom = new_opts.fetch(:margin_bottom, margin_bottom)
    end
  end

  # Dimenions for object that do not depend on their parent and do not
  # participate in slot-based layout.
  class AbsoluteDimensions < Dimensions
    # @private
    def initialize(*args)
      super(nil, *args)
    end

    # Absolutely positioned elements don't include laying out content, so they
    # aren't considered to "take up space"
    def takes_up_space?
      false
    end
  end

  # Dimensions for objects that are defined by their parents, delegating method
  # calls to crucial methods to the parent if the instance variable isn't set
  class ParentDimensions < Dimensions
    # @private
    def init_x_and_y_dimensions
      @x_dimension = ParentDimension.new @parent.x_dimension,
                                         @left_top_as_center
      @y_dimension = ParentDimension.new @parent.y_dimension,
                                         @left_top_as_center
    end
  end

  # Plumbing for depends on delegating to dimensions when making style-based
  # access to left, top, etc.
  #
  # #dimensions method being present that returns a Dimensions object
  #
  # @private
  module DimensionsDelegations
    extend Forwardable

    UNDELEGATED_METHODS = [:to_s].freeze
    CANDIDATE_METHODS = Dimensions.public_instance_methods(false) - UNDELEGATED_METHODS

    WRITER_METHODS    = CANDIDATE_METHODS.select { |meth| meth.to_s.end_with?("=") }
    DELEGATED_METHODS = CANDIDATE_METHODS - WRITER_METHODS

    def_delegators :dimensions, *DELEGATED_METHODS

    # For performance reasons, it's critical to write out dimension values to
    # the styles hash directly when they change, so do that here.
    WRITER_METHODS.each do |meth|
      key = meth.to_s.sub("=", "").to_sym
      define_method(meth) do |value|
        @style[key] = value if defined?(@style)
        dimensions.send(meth, value)
      end
    end

    def adjust_current_position(*_)
      # no-op by default for almost all elements
    end
  end

  # depends on a #dsl method to forward to (e.g. for backend objects)
  #
  # @private
  module BackendDimensionsDelegations
    extend Forwardable

    def_delegators :dsl, *DimensionsDelegations::CANDIDATE_METHODS

    def redraw_target
      @dsl
    end
  end
end
