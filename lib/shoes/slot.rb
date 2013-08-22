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
      %w[left top width height margin margin_left margin_top margin_right margin_bottom].each do |v|
        instance_variable_set "@#{v}", opts[v.to_sym]
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

    def positioning x, y, max
      setup_dimensions
      if parent.is_a?(Flow) and x + @width <= parent.left + parent.width
        @left, @top = x + parent.margin_left, max.top + parent.margin_top
        @height = contents_alignment
        max = self if max.height < @height
      else
        @left, @top = parent.left + parent.margin_left, max.top + max.height + parent.margin_top
        @height = contents_alignment
        max = self
      end
      max.height = @height unless @height == 0
      max
    end

    def contents_alignment
      x, y = left.to_i, top.to_i
      max = TopHeightData.new
      max.top, max.height = y, 0
      slot_top, slot_height = y, 0

      contents.each do |element|
        next if element.is_a?(Shoes::Background) or element.is_a?(Shoes::Border)
        tmp = max
        max = element.positioning x, y, max
        x = element.right
        y = element.bottom
        slot_height = max.top + max.height - slot_top unless max == tmp
      end
      slot_height
    end

    private
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
