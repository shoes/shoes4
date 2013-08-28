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
    @strong_breadsticks ||= app.strong breadsticks
  end

  def em
    @em ||= app.em breadsticks
  end

  def code
    @code ||= app.code breadsticks
  end

  def ins
    @ins ||= app.ins even_better
  end

  def fg
    @fg ||= app.fg strong, app.white
  end

  def strong
    @strong ||= app.strong ins
  end

  def bg
    @bg ||= app.bg fg, app.rgb(255, 0, 192)
  end

  def sub
    @sub ||= app.sub fine
  end
end
