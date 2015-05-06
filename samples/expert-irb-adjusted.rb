require 'irb/ruby-lex'
require 'stringio'

class MimickIRB < RubyLex
  attr_accessor :started

  class Continue < StandardError; end
  class Empty < StandardError; end

  def initialize
    super
    set_input(StringIO.new)
  end

  def run(str)
    obj = nil
    @io << str
    @io.rewind
    l = lex
    if l
      case l.strip
      when "reset"
        @line = ""
      when "time"
        @line = "puts %{You started \#{IRBalike.started.since} ago.}"
      else
        @line << l << "\n"
        if @ltype or @continue or @indent > 0
          raise Continue
        end
      end
    else
      raise Empty if @line == ''
    end
    unless @line.empty?
      obj = eval @line, TOPLEVEL_BINDING, "(irb)", @line_no
    end
    @line_no += @line.scan(/\n/).length
    @line = ''
    @exp_line_no = @line_no

    @indent = 0
    @indent_stack = []

    $stdout.rewind
    output = $stdout.read
    $stdout.truncate(0)
    $stdout.rewind
    [output, obj]
  rescue Object => e
    case e
      when Empty, Continue
      else @line = ""
    end
    raise e
  ensure
    set_input(StringIO.new)
  end

end

CURSOR = ">>"
IRBalike = MimickIRB.new
$stdout = StringIO.new

Shoes.app do
  @str, @cmd = [CURSOR + " "], ""
  background "#555"
  @scroll = stack do
    background "#555"
    stack width: 1.0, height: 50 do
      para "Interactive Ruby ready.", fill: white, stroke: red
    end
    @console = para(*@str, font: "Lucida Console", stroke: "#dfa")
    @console.cursor = -1
  end
  keypress do |k|
    case k
    when "\n"
      begin
        out, obj = IRBalike.run(@cmd + ';')
        @str += ["#{@cmd}\n",
          fg("#{out}=> #{obj.inspect}\n", "#fda"),
          "#{CURSOR} "]
        @cmd = ""
      rescue MimickIRB::Empty
      rescue MimickIRB::Continue
        @str += ["#{@cmd}\n.. "]
        @cmd = ""
      rescue Object => e
        @str += ["#{@cmd}\n", fg("#{e.class}: #{e.message}\n", "#fcf"),
          "#{CURSOR} "]
        @cmd = ""
      end
    when String
      @cmd += k
    when :backspace
      @cmd.slice!(-1)
    when :tab
      @cmd += "  "
    when :alt_q
      exit
    when :alt_c
      self.clipboard = @cmd
    when :alt_v
      @cmd += self.clipboard
    end
    @console.replace(*(@str + [@cmd]))
    tmp = @scroll.height - app.height
    @scroll.scroll_top = tmp > 0 ? tmp : 0
  end
end
