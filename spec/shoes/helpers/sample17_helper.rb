# Emulates samples/sample17.rb
#
#   Shoes.app width: 240, height: 95 do
#     para 'Testing, test, test. ',
#       strong('Breadsticks. '),
#       em('Breadsticks. '),
#       code('Breadsticks. '),
#       bg(fg(strong(ins('EVEN BETTER.')), white), rgb(255, 0, 192)),
#       sub('fine!')
#   end
#
class Sample17Helper
  
  def initialize(app)
    # This gives us the Shoes::App
    @app = app.app
  end
  
  def create_para
    @app.para("Testing, test, test. ", strong_breadsticks, em, code, bg, sub)
  end
  
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
    @strong_breadsticks ||= @app.strong breadsticks
  end

  def em
    @em ||= @app.em breadsticks
  end

  def code
    @code ||= @app.code breadsticks
  end

  def ins
    @ins ||= @app.ins even_better
  end

  def fg
    @fg ||= @app.fg strong, Shoes::COLORS[:white]
  end

  def strong
    @strong ||= @app.strong ins
  end

  def bg
    @bg ||= @app.bg fg, Shoes::Color.new(255, 0, 192)
  end

  def sub
    @sub ||= @app.sub fine
  end
end
