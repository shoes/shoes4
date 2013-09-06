# Helpers for creating nested text fragments. See spec/shoes/text_block_spec.rb
module TextFragmentHelpers
  def breadsticks
    "Breadsticks. "
  end

  def even_better
    "EVEN BETTER."
  end

  def fine
    "fine!"
  end

  def strong_breadsticks
    @strong_breadsticks ||= text :strong, breadsticks
  end

  def em
    @em ||= text :em, breadsticks
  end

  def code
    @code ||= text :code, breadsticks
  end

  def ins
    @ins ||= text :ins, even_better
  end

  def fg
    @fg ||= text :fg, strong, Shoes::COLORS[:white]
  end

  def strong
    @strong ||= text :strong, ins
  end

  def bg
    @bg ||= text :bg, fg, Shoes::Color.new(255, 0, 192)
  end

  def sub
    @sub ||= text :sub, fine
  end

  def text(style, string, color = nil)
    Shoes::Text.new style, Array(string), color
  end
end
