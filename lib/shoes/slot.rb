class Shoes
  class Slot
    include Shoes::DSL
    include Shoes::Common::Margin
    include Shoes::Common::Clickable
    include Shoes::CommonMethods

    RECOGNIZED_OPTION_VALUES = %w[left top width height margin margin_left margin_top margin_right margin_bottom]

    DEFAULT_LEFT   = 0
    DEFAULT_TOP    = 0
    DEFAULT_WIDTH  = 1.0
    DEFAULT_HEIGHT = 0

    attr_reader :parent, :gui, :contents, :hidden, :blk, :app
    attr_accessor :width, :height, :left, :top

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
      @app      = app
      @parent   = parent
      @contents = []
      @style    = {}

      init_values_from_options(opts)
      @fixed_height = @height || false
      set_default_dimension_values
      @blk = blk
    end

    def set_default_dimension_values
      @left   ||= 0
      @top    ||= 0
      @width  ||= 1.0
      @height ||= 0
    end

    def init_values_from_options(opts)
      RECOGNIZED_OPTION_VALUES.each do |value|
        instance_variable_set "@#{value}", opts[value.to_sym]
      end
    end

    def right
      left + width
    end

    def bottom
      top + height
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
      gui.dsl.contents << element
    end

    def append &blk
      eval_block blk
    end

    def contents_alignment
      last_position = position_contents
      determine_slot_height(last_position)
    end

    protected
    def setup_dimensions
      convert_percentage_dimensions_to_pixel
      apply_margins
    end

    def convert_percentage_dimensions_to_pixel
      @width = (@width * parent.width).to_i if @width.is_a? Float
      @height = (@height * parent.height).to_i if @height.is_a? Float
    end

    def apply_margins
      @width  -= (margin_left + margin_right)
      @height -= (margin_top + margin_bottom)
    end

    def position_contents
      current_position = CurrentPosition.new left + margin_left,
                                             top + margin_top,
                                             top + margin_top
      contents.each do |element|
        current_position = positioning(element, current_position)
      end
      current_position
    end

    def positioning(element, current_position)
      if takes_up_space?(element)
        position_element element, current_position
        element.contents_alignment if element.respond_to? :contents_alignment
        current_position = update_current_position(current_position, element)
      end
      current_position
    end

    def position_element(element, current_position)
      raise 'position_element is subclass responsibility'
    end

    def update_current_position(current_position, element)
      current_position.x = element.right
      current_position.y = element.top
      if current_position.max_bottom < element.bottom
        current_position.max_bottom = element.bottom
      end
      current_position
    end

    def position_in_current_line(element, current_position)
      element._position current_position.x, current_position.y
    end

    def move_to_next_line(element, current_position)
      element._position self.left + margin_left, current_position.max_bottom
    end

    def fits_on_the_same_line?(element, current_x)
      current_x + element.width <= right
    end

    def takes_up_space?(element)
      not (element.is_a?(Shoes::Background) or element.is_a?(Shoes::Border))
    end

    def determine_slot_height(last_position)
      content_height = compute_content_height(last_position)
      @height = content_height if has_variable_height?
      content_height
    end

    def compute_content_height(last_position)
      last_position.max_bottom - self.top
    end

    def has_variable_height?
      not @fixed_height
    end
  end

  CurrentPosition = Struct.new(:x, :y, :max_bottom)

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
