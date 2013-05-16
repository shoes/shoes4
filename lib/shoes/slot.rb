require 'shoes/common/margin'

module Shoes
  class Slot
    include Shoes::DSL
    include Shoes::Common::Margin
    include Shoes::Common::Clickable

    attr_reader :parent, :gui, :contents, :hidden
    attr_reader :blk, :app
    attr_accessor :width, :height, :left, :top

    def initialize parent, opts={}, &blk
      @parent = parent
      @contents, @style = [], {}

      %w[app left top width height margin margin_left margin_top margin_right margin_bottom].each do |v|
        instance_variable_set "@#{v}", opts[v.to_sym]
      end

      @left ||= 0
      @top ||= 0
      @width ||= 1.0
      @height ||= 0
      @init_height = @height
      @blk = blk
      @margin = opts[:margin]
      set_margin

      @gui = Shoes.configuration.backend_for(self, @parent.gui)

      @app.current_slot = self
      begin
        @app.instance_eval &blk if blk
      rescue
        $shoes_is_included.instance_eval &blk if $shoes_is_included
      end
      @app.current_slot = parent
    end

    def current_slot ; @app.current_slot ; end

    def clear &blk
      super
      eval_block blk
    end

    def eval_block blk
      @app.current_slot = self
      @app.instance_eval &blk if blk
      @app.current_slot = parent
      @app.gui.flush
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
      if (parent.is_a?(Flow) or parent.is_a?(App)) and x + @width <= parent.left + parent.width - parent.margin_left - parent.margin_right
        @left, @top = x + parent_margin_left, parent_margin_top
        @height = contents_alignment(self) + parent_margin_bottom
        max = self if max.height < @height
      else
        @left, @top = parent.left + parent_margin_left, max.top + max.height + parent_margin_top
        @height = contents_alignment(self) + parent_margin_bottom
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

    def parent_margin_left
      parent.is_a?(Shoes::App) ? @margin_left : parent.margin_left
    end
    def parent_margin_right
      parent.is_a?(Shoes::App) ? @margin_right : parent.margin_right
    end
    def parent_margin_top
      parent.is_a?(Shoes::App) ? @margin_top : parent.margin_top
    end
    def parent_margin_bottom
      parent.is_a?(Shoes::App) ? @margin_bottom : parent.margin_bottom
    end

    def contents_alignment slot
      x, y = slot.left.to_i, slot.top.to_i
      max = Struct.new(:top, :height).new
      max.top, max.height = y, 0
      slot_height, slot_top = 0, y

      slot.contents.each do |ele|
        next if ele.is_a?(Shoes::Background) or ele.is_a?(Shoes::Border)
        tmp = max
        max = ele.positioning x, y, max
        x, y = ele.left + ele.width, ele.top + ele.height
        if max == tmp
          #slot_height = max.top + max.height - slot_top
        else
          slot_height = max.top + max.height - slot_top
        end
      end
      slot_height
    end
  end
  class Flow < Slot; end
  class Stack < Slot; end
end
