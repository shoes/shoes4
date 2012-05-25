module Accordion
  def open_page stack
    active = app.slot.contents.map { |x| x.contents[1] }.
      detect { |x| x.height > 0 }
    return if active == stack
    a = animate 60 do
      stack.height += 20
      active.height = 240 - stack.height if active
      a.stop if stack.height == 240
    end
  end
  def page title, text
    @pages ||= []
    @pages <<
      stack do
        page_text = nil
        stack :width => "100%" do
          background "#fff".."#eed"
          hi = background "#ddd".."#ba9", :hidden => true
          para link(title) {}, :size => 26
          hover { hi.show }
          leave { hi.hide }
          click { open_page page_text }
        end
        page_text =
          stack :width => "100%", :height => (@pages.empty? ? 240 : 0) do
            stack :margin => 10 do
              text.split(/\n{2,}/).each do |pg|
                para pg
              end
            end
          end
      end
  end
end

Shoes.app do
  extend Accordion
  style(Link, :stroke => black, :underline => nil, :weight => "strong")
  style(LinkHover, :stroke => black, :fill => nil, :underline => nil)

  page "0.0", <<-'END'
There is a thought
I have just had
Which I don’t care to pass to
Anyone at all at this time.

I have even forgotten it now,
But kept only the pleasures
Of my property
And of my controlled mental slippage.
END
  page "0.1", <<-'END'
My eyes have blinked again
And I have just realized
This upright world
I have been in.

My eyelids wipe
My eyes hundreds of times
Reseting and renovating
The scenery.
END
  page "0.2", <<-'END'
Sister, without you,
The universe would
Have such a hole through it,
Where infinity has been shot.

This cannot be, though.
There will always be room
For you—all of us are
Holding the way open.
END
end
