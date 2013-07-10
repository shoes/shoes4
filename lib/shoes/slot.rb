require 'shoes/common/margin'

class Shoes
  class Slot
    include Shoes::DSL
    include Shoes::Common::Margin
    include Shoes::Common::Clickable

    attr_reader :parent, :gui, :contents, :hidden
    attr_reader :blk, :app
    attr_accessor :width, :height, :left, :top

    def initialize(app, parent, opts={}, &blk)
      @app = app
      @parent = parent
      @contents, @style = [], {}

      %w[left top width height margin margin_left margin_top margin_right margin_bottom].each do |v|
        instance_variable_set "@#{v}", opts[v.to_sym]
      end

      @left ||= 0
      @top ||= 0
      @width ||= 1.0
      @height ||= 0
      @init_height = @height
      @blk = blk

      set_margin

      @gui = Shoes.configuration.backend_for(self, @parent.gui)

      eval_block blk
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
      @init_width ||= @width
      if @init_width.is_a? Float
        @width = (parent.width * @init_width).to_i
        @width -= margin_left + margin_right
      else
        @width = @init_width - margin_left - margin_right
      end
      if parent.is_a?(Flow) and x + @width <= parent.left + parent.width
        @left, @top = x + parent.margin_left, max.top + parent.margin_top
        @height = contents_alignment self
        max = self if max.height < @height
      else
        @left, @top = parent.left + parent.margin_left, max.top + max.height + parent.margin_top
        @height = contents_alignment self
        max = self
      end
      case @init_height
      when 0
      when Float
        max.height = @height = (parent.height * @init_height).to_i
      else
        max.height = @height = @init_height
      end
      max
    end

    def contents_alignment slot
      x, y = slot.left.to_i, slot.top.to_i
      max = TopHeightData.new
      max.top, max.height = y, 0
      slot_height, slot_top = 0, y

      slot.contents.each do |ele|
        next if ele.is_a?(Shoes::Background) or ele.is_a?(Shoes::Border)
        tmp = max
        max = ele.positioning x, y, max
        x, y = ele.left + ele.width, ele.top + ele.height
        unless max == tmp
          slot_height = max.top + max.height - slot_top
        end
      end
      slot_height
    end
  end

  TopHeightData = Struct.new(:top, :height)
  class Flow < Slot; end
  class Stack < Slot; end
end
