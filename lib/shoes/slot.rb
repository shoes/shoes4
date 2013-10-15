class Shoes
  class Slot
    include DSL
    include Common::Margin
    include Common::Clickable
    include CommonMethods
    include DimensionsDelegations

    RECOGNIZED_OPTION_VALUES = %w[margin margin_left margin_top margin_right margin_bottom]

    attr_reader :parent, :gui, :contents, :blk, :app, :dimensions

    def initialize(app, parent, opts={}, &blk)
      init_attributes(app, parent, opts, blk)
      set_margin
      setup_dimensions
      @parent.add_child self

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      unslot if opts[:left] || opts[:top]
      eval_block blk
      contents_alignment
    end

    def init_attributes(app, parent, opts, blk)
      @app          = app
      @parent       = parent
      @contents     = SlotContents.new
      @style        = {}
      @blk          = blk
      @dimensions   = Dimensions.new parent, opts
      @fixed_height = height || false
      @prepending   = false
      set_default_dimension_values

      init_values_from_options(opts)
    end

    def set_default_dimension_values
      self.width          ||= 1.0
      self.height         ||= 0
      self.absolute_left  ||= 0
      self.absolute_top   ||= 0
    end

    def init_values_from_options(opts)
      RECOGNIZED_OPTION_VALUES.each do |value|
        instance_variable_set "@#{value}", opts[value.to_sym]
      end
    end

    def current_slot
      @app.current_slot
    end

    def clear &blk
      super
      eval_block blk
    end

    def eval_block blk
      @app.current_slot = self
      blk.call if blk
      @app.current_slot = parent
    end

    def add_child(element)
      contents.add_element element
    end

    def append(&blk)
      eval_block blk
    end

    def prepend(&blk)
      contents.prepend do
        eval_block blk
      end
    end

    def contents_alignment
      last_position = position_contents
      determine_slot_height(last_position)
    end

    protected
    def setup_dimensions
      apply_margins
    end

    def apply_margins
      @actual_width  = width  - (margin_left + margin_right)
      @actual_height = height - (margin_top + margin_bottom)
    end

    CurrentPosition = Struct.new(:x, :y, :max_bottom)

    def position_contents
      current_position = CurrentPosition.new absolute_left + margin_left,
                                             absolute_top + margin_top,
                                             absolute_top + margin_top
      contents.each do |element|
        current_position = positioning(element, current_position)
      end
      current_position
    end

    def positioning(element, current_position)
      return current_position unless takes_up_space?(element)
      position_element element, current_position
      element.contents_alignment if element.respond_to? :contents_alignment
      current_position = update_current_position(current_position, element)
      current_position
    end

    def position_element(element, current_position)
      raise 'position_element is subclass responsibility'
    end

    def update_current_position(current_position, element)
      return current_position if element.absolutely_positioned?
      current_position.x = element.absolute_right
      current_position.y = element.absolute_top
      if current_position.max_bottom < element.absolute_bottom
        current_position.max_bottom = element.absolute_bottom
      end
      current_position
    end

    def position_in_current_line(element, current_position)
      element._position position_x(current_position.x, element),
                        position_y(current_position.y, element)
    end

    def move_to_next_line(element, current_position)
      element._position position_x(self.absolute_left + margin_left, element),
                        position_y(current_position.max_bottom, element)
    end

    def position_x(relative_x, element)
      if element.absolute_x_position?
        self.absolute_left + element.left
      else
        relative_x
      end
    end

    def position_y(relative_y, element)
      if element.absolute_y_position?
        self.absolute_top + element.top
      else
        relative_y
      end
    end

    def fits_on_the_same_line?(element, current_x)
      current_x + element.width <= absolute_left + @actual_width
    end

    def takes_up_space?(element)
      not (element.is_a?(Shoes::Background) or element.is_a?(Shoes::Border))
    end

    def determine_slot_height(last_position)
      content_height = compute_content_height(last_position)
      self.height = content_height if has_variable_height?
      content_height
    end

    def compute_content_height(last_position)
      last_position.max_bottom - self.absolute_top
    end

    def has_variable_height?
      not @fixed_height
    end
  end

  class Flow < Slot
    def position_element(element, current_position)
      if fits_on_the_same_line?(element, current_position.x)
        position_in_current_line(element, current_position)
      else
        move_to_next_line(element, current_position)
      end
    end
  end

  class Stack < Slot
    def position_element(element, current_position)
      move_to_next_line(element, current_position)
    end
  end
end
