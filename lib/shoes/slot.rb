module Shoes
  class Slot
    include Shoes::ElementMethods

    attr_reader :parent, :gui, :contents
    attr_reader :blk
    attr_accessor :width, :height, :left, :top, :margin, :margin_left, :margin_right, :margin_top


    def initialize parent, opts={}, &blk
      @parent = parent
      @contents, @style = [], {}

      %w[app left top width height margin margin_left margin_top].each do |v|
        instance_variable_set "@#{v}", opts[v.to_sym]
      end

      @width ||= 1.0
      @height ||= 0
      @blk = blk

      @gui = Shoes.configuration.backend_for(self, @parent.gui)

      @app.current_slot = self
      @app.instance_eval &blk if blk
    end

    def app
      @parent.app
    end

    def add_child(element)
      gui.dsl.contents << element
    end

    def positioning x, y, max
      @init_width = @width if @width.is_a? Float
      @width = (parent.width * @init_width).to_i if @init_width
      if parent.is_a?(Flow) and x + @width <= parent.left + parent.width
        @left, @top = x, max.top
        @height = contents_alignment self
        max = self if max.height < @height
      else
        @left, @top = parent.left, max.top + max.height
        @height = contents_alignment self
        max = self
      end
      max
    end

    def contents_alignment slot
      x, y = slot.left.to_i, slot.top.to_i
      max = Struct.new(:top, :height).new
      max.top, max.height = y, 0
      slot_height, slot_top = 0, y

      slot.contents.each do |ele|
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
  class Flow < Slot; end
  class Stack < Slot; end
end
