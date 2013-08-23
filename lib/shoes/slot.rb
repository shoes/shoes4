class Shoes
  class Slot
    include Shoes::DSL
    include Shoes::Common::Margin
    include Shoes::Common::Clickable
    include Shoes::CommonMethods

    RECOGNIZED_OPTION_VALUES = %w[left top width height margin margin_left margin_top margin_right margin_bottom]

    attr_reader :parent, :gui, :contents, :hidden, :blk, :app
    attr_accessor :width, :height, :left, :top

    def initialize(app, parent, opts={}, &blk)
      init_attributes(app, parent, opts, blk)
      set_margin
      setup_dimensions

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      eval_block blk
    end

    def init_attributes(app, parent, opts, blk)
      @app      = app
      @parent   = parent
      @contents = []
      @style    = {}

      init_values_from_options(opts)
      set_default_dimension_values
      @init_width  = @width
      @init_height = @height
      @blk         = blk
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

    def position_element element, current_x, _, max
      if stays_on_the_same_line?(element, current_x)
        max = position_in_current_line(element, max, current_x)
      else
        max = move_to_next_line(element, max)
      end
      max
    end

    def contents_alignment
      setup_dimensions
      current_x = left
      current_y = top
      max = TopHeightData.new current_y, 0
      slot_height = 0

      contents.each do |element|
        if takes_up_space?(element)
          max = position_element element, current_x, current_y, max
          current_x = element.right
          current_y = element.bottom
          slot_height = max.top + max.height - self.top
        end
      end
      if @init_height == 0
        @height = slot_height
      else
        @height = @init_height
      end
      slot_height
    end

    private
    def position_in_current_line(element, max, current_x)
      left   = current_x + margin_left
      top    = max.top + margin_top
      element.contents_alignment if element.respond_to? :contents_alignment
      max = element if max.height < element.height
      element._position left, top
      max
    end

    def move_to_next_line(element, max)
      left   = self.left + margin_left
      top    = max.top + max.height + margin_top
      element.contents_alignment if element.respond_to? :contents_alignment
      element._position left, top
      element
    end

    def stays_on_the_same_line?(element, x)
      element.parent.is_a?(Flow) and fits_without_wrapping?(element, x)
    end

    def takes_up_space?(element)
      not (element.is_a?(Shoes::Background) or element.is_a?(Shoes::Border))
    end

    def setup_dimensions
      convert_percentage_dimensions_to_pixel
      apply_margins
    end

    def apply_margins
      @width  -= (margin_left + margin_right)
      @height -= (margin_top + margin_bottom)
    end

    def convert_percentage_dimensions_to_pixel
      @width = (@init_width * parent.width).to_i if @init_width.is_a? Float
      @height = (@init_height * parent.height).to_i if @init_height.is_a? Float
    end
  end

  TopHeightData = Struct.new(:top, :height)
  class Flow < Slot; end
  class Stack < Slot; end
end
