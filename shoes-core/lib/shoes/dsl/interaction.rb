# frozen_string_literal: true
class Shoes
  module DSL
    module Interaction
      def mouse
        [@__app__.mouse_button, @__app__.mouse_pos[0], @__app__.mouse_pos[1]]
      end

      def motion(&blk)
        @__app__.mouse_motion << blk
      end

      def resize(&blk)
        @__app__.add_resize_callback blk
      end

      # hover and leave just delegate to the current slot as hover and leave
      # are just defined for slots but self is always the app.
      def hover(&blk)
        @__app__.current_slot.hover(&blk)
      end

      def leave(&blk)
        @__app__.current_slot.leave(&blk)
      end

      def keypress(&blk)
        Shoes::Keypress.new @__app__, &blk
      end

      def keyrelease(&blk)
        Shoes::Keyrelease.new @__app__, &blk
      end

      def append
        yield if block_given?
      end

      def visit(url)
        match_data = nil
        url_data = Shoes::URL.urls.find { |page, _| match_data = page.match url }
        return unless url_data
        action_proc = url_data[1]
        url_argument = match_data[1]
        clear do
          @__app__.location = url
          action_proc.call self, url_argument
        end
      end

      def scroll_top
        @__app__.scroll_top
      end

      def scroll_top=(n)
        @__app__.scroll_top = n
      end

      def clipboard
        @__app__.clipboard
      end

      def clipboard=(str)
        @__app__.clipboard = str
      end

      def download(name, args = {}, &blk)
        create(Shoes::Download, name, args, &blk).tap(&:start)
      end

      def gutter
        @__app__.gutter
      end
    end
  end
end
