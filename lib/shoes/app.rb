require 'shoes/element_methods'
require 'shoes/color'
require 'facets/hash'

def window(*a, &b)
  Shoes.app(*a, &b)
end


module Shoes

  def self.app(opts={}, &blk)
    Shoes::App.new(opts, &blk)
  end

  class App

    DEFAULTS = { 'width' => 800, 'height' => 600, 'title' => "Shoooes!"}
    DEFAULT_STYLE = { :stroke => Shoes::COLORS[:black], :strokewidth => 1 }

    include Shoes::ElementMethods

    attr_accessor :elements, :gui_container
    attr_accessor :opts, :blk

    attr_accessor :width, :height, :title

    def initialize(opts={}, &blk)
      opts.stringify_keys!
      opts = DEFAULTS.merge(opts)
      self.width = opts['width']
      self.height = opts['height']
      self.title = opts['title']
      
      self.opts = opts

      @app = self
      @style = DEFAULT_STYLE

      gui_init

      instance_eval &blk if blk

      gui_open

    end

    #import javax.swing.JPanel
    #import javax.swing.JFrame
    #import java.awt.Dimension
    #import java.awt.FlowLayout
    #import java.awt.BorderLayout
    #import javax.swing.BoxLayout
    #
    #DEFAULT_HEIGHT = 600
    #DEFAULT_WIDTH = 800
    #
    #
    #def xinitialize(opts={}, &blk)
    #  opts.stringify_keys!
    #  height = opts['height'] ||= DEFAULT_HEIGHT
    #  width = opts['width'] ||= DEFAULT_WIDTH
    #
    #  @elements = {}
    #  @frame = JFrame.new()
    #
    #  @container = @frame.get_content_pane
    #
    #  @layout = FlowLayout.new(FlowLayout::LEFT)
    #  #@layout.alignment = FlowLayout::LEFT
    #  @frame.setLayout(@layout)
    #
    #  #flow(opts, &blk)
    #  instance_eval &blk
    #
    #  @frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    #  #@container.border = javax.swing.border.LineBorder.new(java.awt.Color::BLUE, 4, true)
    #  @container.setBackground(java.awt.Color::BLUE)
    #
    #  #@frame.pack()
    #  if opts['pack']
    #    @frame.pack
    #  else
    #    @frame.setSize(Dimension.new(opts['width'], opts['height']))
    #    @container.setSize(Dimension.new(opts['width'], opts['height']))
    #  end
    #  @frame.set_visible(true)
    #
    #  #debugger; 1
    #
    #end

    #def button(opts={}, &blk)
    #
    #  button = Button.new(@current_panel,opts, &blk)
    #  @elements[button.identifier] = button
    #  button
    #end

    #def image(path, opts={})
    #  image = Image.new(path, @current_panel, opts)
    #  @elements[image.identifier] = image
    #  image
    #end
    #
    #def edit_line(opts={})
    #  eline = Edit_line.new(@current_panel, opts)
    #  @elements[eline.identifier] = eline
    #  eline
    #end
    #
    #def text_box(opts={})
    #  tbox = Text_box.new(@current_panel, opts)
    #  @elements[tbox.identifier] = tbox
    #  tbox
    #end
    #
    #def check(opts={}, &blk)
    #  cbox = Check.new(@current_panel, opts)
    #  @elements[cbox.identifier] = cbox
    #  cbox
    #end
    #
    #def stack(opts={}, &blk)
    #  tstack = Stack.new(opts)
    #  layout(tstack, &blk)
    #end
    #
    ##def flow(opts={}, &blk)
    ##  tflow = Flow.new(@container, opts, &blk)
    ##  #layout(tflow, &blk)
    ##end
    #
    #def layout(layer, &blk)
    #  parent = @current_panel
    #  @current_panel = layer.panel
    #  instance_eval &blk
    #  parent.add(@current_panel)
    #  @current_panel = parent
    #end
  end
end
