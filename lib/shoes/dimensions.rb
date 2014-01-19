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
		AXIS_HASH = {'left' => 'x', 'right' => 'x', 'top' => 'y'}
		SIDE_HASH = {'width' => 'left', 'height' => 'top'}
		DIRECTION_HASH = {'left' => 'width', 'right' => 'width', 
			'top' => 'height', 'bottom' => 'height'}
    OPPOSITE_HASH = {'right' => 'left', 'left' => 'right', 
				'top' => 'bottom', 'bottom' => 'top'}


    def initialize(parent, left_or_hash = nil, top = nil, width = nil,
                   height = nil, opts = {})
      @parent = parent
      if hash_as_argument?(left_or_hash)
        init_with_hash(left_or_hash)
      else
        init_with_arguments(left_or_hash, top, width, height, opts)
      end
    end

	  ['left', 'top'].each do |side|		
	    define_method(side) do
	      value = instance_variable_get("@#{side}") || 0
	      value = send("adjust_#{side}_for_center", value) if left_top_as_center?
	      value
	    end

	    define_method("#{side}=") do |value|
	      return if value.nil?
	      instance_variable_set("@#{side}", value)
	      instance_variable_set("@absolute_#{axis(side)}_position", true)
	    end

	    define_method("element_#{side}") do
	      return nil if send("absolute_#{side}").nil?
	      send("absolute_#{side}") + send("margin_#{side}")
	    end
	  end
	
	  ['right', 'bottom'].each do |side|
	    define_method(side) do
	      return send(opposite(side)) if send(direction(side)).nil?
	      send(opposite(side)) + send(direction(side)) + PIXEL_COUNTING_ADJUSTMENT
	    end
	
	    define_method("element_#{side}") do
	      return nil if send("element_#{opposite(side)}").nil? || send("element_#{direction(side)}").nil?
	      send("element_#{opposite(side)}") + send("element_#{direction(side)}") + PIXEL_COUNTING_ADJUSTMENT
	    end
	
	    define_method("absolute_#{side}") do
	      return send("absolute_#{opposite(side)}") if send(direction(side)).nil?
	      send("absolute_#{opposite(side)}") + send(direction(side)) + PIXEL_COUNTING_ADJUSTMENT
	    end
	  end
	
	  ['width', 'height'].each do |direction|
	    define_method(direction) do
	      calculate_dimension(direction.to_sym)
	    end

	    define_method("element_#{direction}") do
	      return nil if send(direction).nil?
	      side = side(direction)
	      send(direction) - (send("margin_#{side}") + send("margin_#{opposite(side)}"))
	    end

	    define_method("element_#{direction}=") do |value|
	      side = side(direction)
	      self.send("#{direction}=", send("margin_#{side}") + value + send("margin_#{opposite(side)}"))
	    end
	  end
	
	  ['x', 'y'].each do |axis|
	    define_method("absolute_#{axis}_position?") do
	      instance_variable_get("@absolute_#{axis}_position")
	    end
	  end

    def absolutely_positioned?
      absolute_x_position? || absolute_y_position?
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

	  def axis(side)
			AXIS_HASH[side]
	  end

	  def direction(side)
			DIRECTION_HASH[side]
	  end

	  def opposite(side)
			OPPOSITE_HASH[side]
	  end

	  def side(measure)
			SIDE_HASH[measure]
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
