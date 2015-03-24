class Shoes
  class Dimension
    attr_reader :parent
    attr_accessor :absolute_start
    protected :parent # we shall not mess with parent,see #495

    # in case you wonder about the -1... it is used to adjust the right and
    # bottom values. Because right is not left + width but rather left + width -1
    # Let me give you an example:
    # Say left is 20 and we have a width of 100 then the right must be 119,
    # because you have to take pixel number 20 into account so 20..119 is 100
    # while 20..120 is 101. E.g.:
    # (20..119).size => 100
    PIXEL_COUNTING_ADJUSTMENT = -1

    def initialize(parent = nil, start_as_center = false)
      @parent          = parent
      @start_as_center = start_as_center
    end

    def start
      value = basic_start_value
      value = adjust_start_for_center(value) if start_as_center?
      value
    end

    def end
      @end || report_relative_to_parent_end
    end

    def extent
      result = @extent
      if @parent
        result = calculate_relative(result) if @extent_relative
        result = calculate_negative(result) if @extent_negative
      end
      result
    end

    def extent=(value)
      @extent = value
      @extent = parse_from_string @extent if string? @extent

      @extent_relative = relative?(@extent)
      @extent_negative = negative?(@extent)

      @extent
    end

    def absolute_end
      return absolute_start if extent.nil? || absolute_start.nil?
      absolute_start + extent + PIXEL_COUNTING_ADJUSTMENT
    end

    def element_extent
      my_extent = extent
      if my_extent.nil?
        nil
      else
        extent - (margin_start + margin_end)
      end
    end

    def element_extent=(value)
      self.extent = if value.nil?
                      nil
                    else
                      margin_start + value + margin_end
                    end
    end

    def element_start
      return nil if absolute_start.nil?
      absolute_start + margin_start + displace_start
    end

    def element_end
      return nil if element_start.nil? || element_extent.nil?
      element_start + element_extent + PIXEL_COUNTING_ADJUSTMENT
    end

    def absolute_start_position?
      !@start.nil?
    end

    def absolute_end_position?
      !@end.nil?
    end

    def absolute_position?
      absolute_start_position? || absolute_end_position?
    end

    def positioned?
      absolute_start
    end

    def in_bounds?(value)
      (absolute_start <= value) && (value <= absolute_end)
    end

    # For... reasons it is important to have the value of the instance variable
    # set to nil if it's not modified and then return a default value on the
    # getter... reason being that for ParentDimensions we need to be able to
    # figure out if a value has been modified or if we should consult the
    # parent value - see ParentDimension implementation
    def margin_start
      value_factoring_in_relative(@margin_start, @margin_start_relative)
    end

    def margin_end
      value_factoring_in_relative(@margin_end, @margin_end_relative)
    end

    def displace_start
      value_factoring_in_relative(@displace_start, @displace_start_relative)
    end

    def value_factoring_in_relative(value, relative)
      value ||= 0
      value = calculate_relative value if relative
      value
    end

    def start=(value)
      @start_relative = relative?(value)
      @start = parse_int_value(value)
    end

    def end=(value)
      @end = parse_int_value(value)
    end

    def margin_start=(value)
      @margin_start_relative = relative?(value)
      @margin_start = parse_int_value(value)
    end

    def margin_end=(value)
      @margin_end_relative = relative?(value)
      @margin_end = parse_int_value(value)
    end

    def displace_start=(value)
      @displace_start_relative = relative?(value)
      @displace_start = parse_int_value(value)
    end

    private

    def basic_start_value
      value = @start
      value = calculate_relative value if @start_relative
      value = report_relative_to_parent_start if value.nil?
      value
    end

    def relative?(result)
      # as the value is relative to the parent values bigger than one don't
      # make much sense and are problematic. E.g. through calculations users
      # might end up with values like 5.14 meaning 5 pixel which would get
      # interpreted as 514% of the parent
      # Also check for existance of parent because otherwise relative
      # calculation makes no sense
      result.is_a?(Float) && result <= 1 && @parent
    end

    def calculate_relative(result)
      (result * @parent.element_extent).to_i
    end

    def string?(result)
      result.is_a?(String)
    end

    def negative?(result)
      result && result < 0
    end

    def calculate_negative(result)
      @parent.element_extent + result
    end

    PERCENT_REGEX = /(-?\d+(\.\d+)*)%/

    def parse_from_string(result)
      match = result.gsub(/\s+/, "").match(PERCENT_REGEX)
      return match[1].to_f / 100.0 if match
      int_from_string(result) if valid_integer_string?(result)
    end

    def parse_int_value(input)
      return input if input.is_a?(Integer) || input.is_a?(Float)
      int_from_string(input) if valid_integer_string?(input)
    end

    def int_from_string(result)
      (result.gsub(' ', '')).to_i
    end

    NUMBER_REGEX = /^-?\s*\d+/

    def valid_integer_string?(input)
      input.is_a?(String) && input.match(NUMBER_REGEX)
    end

    def report_relative_to_parent_start
      element_start - parent.element_start if start_exists?
    end

    def report_relative_to_parent_end
      parent.element_end - element_end if end_exists?
    end

    def end_exists?
      element_end && parent && parent.element_end
    end

    def start_exists?
      element_start && parent && parent.element_start
    end

    def start_as_center?
      @start_as_center
    end

    def adjust_start_for_center(value)
      value - extent / 2 if extent && extent > 0
    end
  end

  class ParentDimension < Dimension
    def absolute_start
      @absolute_start ? super : parent.absolute_start
    end

    def start
      @start ? super : parent.start
    end

    def extent
      [extent_in_parent, raw_extent(super)].min
    end

    private

    # Represents the extent, bounded by the parent container's sizing
    def extent_in_parent
      if parent.element_end
        # Why subtracting an absolute from an element dimension value? A
        # diagram helped me reason out what we wanted.
        #
        # parent.      parent.      self.       self.    parent.      parent.
        # abs_start    elem_start   abs_start   abs_end  elem_end     abs_end
        # |   margin   |            |           |        |   margin   |
        #
        # To get our extent respecting the parent's margins, it's our absolute
        # start, minus parent's element end (so we don't blow past the margin)
        parent.element_end - absolute_start - PIXEL_COUNTING_ADJUSTMENT
      else
        # If we hit this, then the extent in parent isn't available and will be
        # ignored by the min call below
        Float::INFINITY
      end
    end

    # Represents the raw value set for extent, either on element or on parent
    def raw_extent(original_value)
      original_value || parent.extent
    end
  end
end
