require 'java'

import javax.swing.JPanel
import javax.swing.JFrame
import java.awt.Dimension
import java.awt.FlowLayout
import java.awt.BorderLayout
import javax.swing.BoxLayout

DEFAULT_HEIGHT = 600
DEFAULT_WIDTH = 800

class BlankWindow
def initialize(opts={}, &blk)
frame = javax.swing.JFrame.new()
frame.getContentPane().add(javax.swing.JLabel.new("Hello World"))
frame.setDefaultCloseOperation(javax.swing.JFrame::EXIT_ON_CLOSE)
frame.pack()
frame.set_visible(true)

  ##opts.stringify_keys!
  #height = opts['height'] ||= DEFAULT_HEIGHT
  #width = opts['width'] ||= DEFAULT_WIDTH
  #
  #@elements = {}
  #@frame = JFrame.new()
  #
  #@container = @frame.get_content_pane
  #
  #@layout = FlowLayout.new(FlowLayout::LEFT)
  ##@layout.alignment = FlowLayout::LEFT
  #@frame.setLayout(@layout)
  #
  ##flow(opts, &blk)
  ##instance_eval &blk
  #
  #@frame.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
  ##@container.border = javax.swing.border.LineBorder.new(java.awt.Color::BLUE, 4, true)
  #@container.setBackground(java.awt.Color::BLUE)
  #
  ##@frame.pack()
  #if opts['pack']
  #  @frame.pack
  #else
  #  @frame.setSize(Dimension.new(opts['width'], opts['height']))
  #  @container.setSize(Dimension.new(opts['width'], opts['height']))
  #end
  #@frame.set_visible(true)
end
end

BlankWindow.new { }

#debugger; 1