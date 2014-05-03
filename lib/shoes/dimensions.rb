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
    extend RenamedDelegate

    attr_writer   :width, :height, :margin_left, :margin_right, :margin_top,
                  :margin_bottom, :top, :left, :right, :bottom
    attr_reader   :parent, :x_dimension, :y_dimension
    attr_accessor :absolute_left, :absolute_top,
                  :displace_left, :displace_top
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

    def absolute_x_position?
      absolute_left_position? || absolute_right_position?
    end

    def absolute_y_position?
      absolute_top_position? || absolute_bottom_position?
    end

    def absolutely_positioned?
      absolute_x_position? || absolute_y_position?
    end

    def positioned?
      absolute_left && absolute_top
    end

    def in_bounds?(x, y)
      absolute_left <= x and x <= absolute_right and
      absolute_top <= y and y <= absolute_bottom
    end

    def margin
      [margin_left, margin_top, margin_right, margin_bottom]
    end

    def margin=(margin)
      margin = [margin, margin, margin, margin] unless margin.is_a? Array
      self.margin_left, self.margin_top,
      self.margin_right, self.margin_bottom =  margin
    end

    # used by positioning code in slot and there to be overwritten if something
    # does not need to be positioned like a background or so
    def needs_to_be_positioned?
      true
    end

    def takes_up_space?
      true
    end

    def self.setup_delegations
      methods_to_rename = Dimension.public_instance_methods false
      renamed_delegate_to :x_dimension, methods_to_rename, 'start'  => 'left',
                                                           'end'    => 'right',
                                                           'extent' => 'width'
      renamed_delegate_to :y_dimension, methods_to_rename, 'start'  => 'top',
                                                           'end'    => 'bottom',
                                                           'extent' => 'height'
    end

    setup_delegations

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
      @left_top_as_center = opts.fetch(:center, false)
      init_x_and_y_dimensions
      general_options opts # order important for redrawing
      self.displace_left = opts.fetch(:displace_left, nil)
      self.displace_top  = opts.fetch(:displace_top, nil)
      self.left   = parse_input_value left
      self.top    = parse_input_value top
      self.width  = width
      self.height = height
    end

    def init_x_and_y_dimensions
      parent_x_dimension = @parent? @parent.x_dimension : nil
      parent_y_dimension = @parent? @parent.y_dimension : nil
      @x_dimension = Dimension.new parent_x_dimension, @left_top_as_center
      @y_dimension = Dimension.new parent_y_dimension, @left_top_as_center
    end

    def general_options(opts)
      self.right = parse_input_value opts[:right]
      self.bottom = parse_input_value opts[:bottom]
      init_margins opts
    end

    def init_margins(opts)
      self.margin        = opts[:margin]
      self.margin_left   = opts.fetch(:margin_left, margin_left)
      self.margin_top    = opts.fetch(:margin_top, margin_top)
      self.margin_right  = opts.fetch(:margin_right, margin_right)
      self.margin_bottom = opts.fetch(:margin_bottom, margin_bottom)
    end

    def int_from_string(result)
      (result.gsub(' ', '')).to_i
    end

    def parse_input_value(input)
      if input.is_a?(Integer) || input.is_a?(Float)
        input
      elsif valid_integer_string?(input)
        int_from_string(input)
      else
        nil
      end
    end

    NUMBER_REGEX = /^-?\s*\d+/

    def valid_integer_string?(input)
      input.is_a?(String) && input.match(NUMBER_REGEX)
    end


  end

  # for objects that do not depend on their parent (get 1.04 as real values)
  class AbsoluteDimensions < Dimensions
    def initialize(*args)
      super(nil, *args)
    end
  end

  # for objects that are more defined by their parents, delegates method calls
  # to crucial methods to the parent if the instance variable isn't set
  class ParentDimensions < Dimensions

    SIMPLE_DELEGATE_METHODS = [:width, :height, :absolute_left, :absolute_top,
                               :margin_left, :margin_top, :margin_right,
                               :margin_bottom, :top, :left]

    SIMPLE_DELEGATE_METHODS.each do |method|
      define_method method do
        if value_modified?(method)
          super
        else
          parent.public_send(method)
        end
      end
    end

    private
    def value_modified?(method)
      instance_variable = ('@' + method.to_s).to_sym
      instance_variable_get(instance_variable)
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
