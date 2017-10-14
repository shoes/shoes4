# frozen_string_literal: true

module Accordion
  OPEN_HEIGHT = 240

  def open_page(stack)
    if stack.height >= OPEN_HEIGHT
      zero_other_pages(stack)
      return
    end

    a = animate 60 do
      stack.height += 20
      decrement_other_pages(stack)
      a.stop if stack.height >= OPEN_HEIGHT
    end
  end

  def other_pages(stack)
    @pages.reject { |page| page == stack }
          .reject { |page| page.height <= 0 }
  end

  def zero_other_pages(stack)
    other_pages(stack).each do |page|
      page.height = 0
    end
  end

  def decrement_other_pages(stack)
    other_pages(stack).each do |page|
      page.height -= [page.height, 20].min
    end
  end

  def page(title, active, text)
    @pages ||= []
    stack do
      page_text = nil
      header = stack width: "100%" do
        background "#fff".."#eed"
        hi = background "#ddd".."#ba9", hidden: true
        para link(title) {}, size: 26
        hover { hi.show }
        leave { hi.hide }
      end

      height = active ? OPEN_HEIGHT : 0
      page_text = stack width: "100%", height: height do
        para text
      end
      @pages << page_text

      header.click do
        open_page(page_text)
      end
    end
  end
end

Shoes.app do
  extend Accordion
  style(Shoes::Link, stroke: black, underline: nil, weight: "strong")
  style(Shoes::LinkHover, stroke: black, fill: nil, underline: nil)

  page "0.0", true, <<-'END'
There is a thought
I have just had
Which I don’t care to pass to
Anyone at all at this time.

I have even forgotten it now,
But kept only the pleasures
Of my property
And of my controlled mental slippage.
END
  page "0.1", false, <<-'END'
My eyes have blinked again
And I have just realized
This upright world
I have been in.

My eyelids wipe
My eyes hundreds of times
Reseting and renovating
The scenery.
END
  page "0.2", false, <<-'END'
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
