# Dimensions is a central class that most Shoes classes use to represent their
# dimensions, e.g. where they are and how much space they are taking up there.
# All the different position types might be confusing. So here is a little list:
#
# Position (left, top, right, bottom)
# plain (left, top, right, bottom)
#   An offset relative to the parent (parents mostly are slots e.g. 
#   flows/stacks), e.g it isn't fully positioned/doesn't flow anymore when set
#
# absolute (absolute_left, absolute_top, absolute_right, absolute_bottom)
#   The absolute position of an element in the app, set by positioning code (in 
#   slot.rb). Might not be the beginning of the element as it also takes margins
#   into account, so it could be the beginning of the margin. Is also used in
#   the positioning code.
#
# element_* (element_left, element_top, element_right, element_bottom)
# Derived from absolute_* but shows the real position of the object, e.g. it
# adds the margins to absolute_* (mostly used by backend drawing code).
#
# Space taken up (width/height)
# plain (width, height)
#   The whole space taken up by this element with margins and everything. Used
#   for positioning/by the user.
#
# element_* (element_width, element_height)
#   Just the space taken up by the element itself without margins.
#   Used by drawing.
#
# Note that this is NOT how margins work in the CSS box model. We derive for
# reasons mentioned in this comment/thread: 
# https://github.com/shoes/shoes4/pull/467#issuecomment-27655355

class Shoes
  class Dimensions
    attr_writer   :width, :height
    attr_reader   :parent
    attr_accessor :absolute_left, :absolute_top, :margin_left, :margin_right,
                  :margin_top, :margin_bottom
    protected :parent # we shall not mess with parent,see #495


    # in case you wonder about the -1... it is used to adjust the right and
    # bottom values. Because right is not left + width but rather left + width -1
    # Let me give you an example:
    # Say left is 20 and we have a width of 100 then the right must be 119,
    # because you have to take pixel number 20 into account so 20..119 is 100
    # while 20..120 is 101. E.g.:
    # (20..119).size => 100
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

    def element_width
      return nil if width.nil?
      width - (margin_left + margin_right)
    end

    def element_height
      return nil if height.nil?
      height - (margin_bottom + margin_top)
    end

    def element_width=(value)
      if value.nil?
        self.width = nil
      else
        self.width = margin_left + value + margin_right
      end
    end

    def element_height=(value)
      if value.nil?
        self.height = nil
      else
        self.height = margin_top + value + margin_bottom
      end
    end

    def element_left
      return nil if absolute_left.nil?
      absolute_left + margin_left
    end

    def element_top
      return nil if absolute_top.nil?
      absolute_top + margin_top
    end

    def element_right
      return nil if element_left.nil? || element_width.nil?
      element_left + element_width + PIXEL_COUNTING_ADJUSTMENT
    end

    def element_bottom
      return nil if element_top.nil? || element_height.nil?
      element_top + element_height + PIXEL_COUNTING_ADJUSTMENT
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
      return left if width.nil?
      left + width + PIXEL_COUNTING_ADJUSTMENT
    end

    def bottom
      return top if height.nil?
      top + height + PIXEL_COUNTING_ADJUSTMENT
    end

    def absolute_right
      return absolute_left if width.nil?
      absolute_left + width + PIXEL_COUNTING_ADJUSTMENT
    end

    def absolute_bottom
      return absolute_top if height.nil?
      absolute_top + height + PIXEL_COUNTING_ADJUSTMENT
    end

    def in_bounds?(x, y)
      absolute_left <= x and x <= absolute_right and
      absolute_top <= y and y <= absolute_bottom
    end

    def margin
      [margin_left, margin_top, margin_right, margin_bottom]
    end

    private
    def hash_as_argument?(left)
      left.respond_to? :fetch
    end

    def init_with_hash(hash)
      init_with_arguments hash.fetch(:left, nil), hash.fetch(:top, nil),
                          hash.fetch(:width, nil), hash.fetch(:height, nil),
                          hash
    end

    def init_with_arguments(left, top, width, height, opts)
      general_options opts # order important for redrawing
      self.left   = left
      self.top    = top
      self.width  = width
      self.height = height
    end

    def init_margins(opts)
      margin = opts.fetch(:margin, 0)
      margin = [margin, margin, margin, margin] if margin.is_a? Integer
      margin_left, margin_top, margin_right, margin_bottom = margin
      @margin_left   = opts.fetch(:margin_left, margin_left)
      @margin_top    = opts.fetch(:margin_top, margin_top)
      @margin_right  = opts.fetch(:margin_right, margin_right)
      @margin_bottom = opts.fetch(:margin_bottom, margin_bottom)
    end

    def general_options(opts)
      @left_top_as_center = opts.fetch(:center, false)
      init_margins opts
    end

    def calculate_dimension(name)
      result = instance_variable_get("@#{name}".to_sym)
      if @parent
        result = calculate_from_string(result) if is_string?(result)
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

    PERCENT_REGEX = /(-?\d+(\.\d+)*)%/

    def is_string?(result)
      result.is_a?(String)
    end

    def calculate_from_string(result)
      match = result.gsub(/\s+/, "").match(PERCENT_REGEX)
      if match
        match[1].to_f / 100.0
      else
        # Shoes eats invalid values, so this protects against non-% strings
        nil
      end
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

  # for objects that do not depend on their parent (get 1.04 as real values)
  class AbsoluteDimensions < Dimensions
    def initialize(*args)
      super(nil, *args)
    end
  end

  # for objects that are more defined by their parents
  class ParentDimensions < Dimensions
    def left
      if @left
        super
      else
        parent.left
      end
    end

    def top
      if @top
        super
      else
        parent.top
      end
    end

    def width
      super || parent.width
    end

    def height
      super || parent.height
    end

    def absolute_left
      super || parent.absolute_left
    end

    def absolute_top
      super || parent.absolute_top
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
