# frozen_string_literal: true

class Shoes
  module DSL
    # DSL methods for handling user interaction (mouse, keyboard) in Shoes
    # applications.
    #
    # @see Shoes::DSL
    module Interaction
      # Return the current position of the mouse.
      #
      # @return [Fixnum, Fixnum, Fixnum] mouse button, x, y
      def mouse
        [@__app__.mouse_button, @__app__.mouse_pos[0], @__app__.mouse_pos[1]]
      end

      # Register code to run when the mouse moves in the application.
      #
      # blk receives the x, y coordinates of the mouse at the time of moving.
      #
      # @param [Proc] blk code to run when the mouse moves
      def motion(&blk)
        @__app__.mouse_motion << blk
      end

      # Register code to run when the window is resized.
      #
      # @param [Proc] blk code to run on resize
      def resize(&blk)
        @__app__.add_resize_callback blk
      end

      # Register code to run when the mouse hovers over the current slot.
      #
      # blk is passed the hovered over element as a parameter.
      #
      # @param [Proc] blk code to run on hover
      def hover(&blk)
        @__app__.current_slot.hover(&blk)
      end

      # Register code to run when the mouse leaves the current slot.
      #
      # blk is passed the left element as a parameter.
      #
      # @param [Proc] blk code to run on leaving
      def leave(&blk)
        @__app__.current_slot.leave(&blk)
      end

      # Register code to run when a key is pressed.
      #
      # Typical text characters are passed to the block as strings.
      # Special keys are identified with symbols. For example :alt_a is the
      # symbol for pressing down the Alt key plus the a key simultaneously.
      #
      # @param [Proc] blk code to when a key is pressed down
      def keypress(&blk)
        Shoes::Keypress.new @__app__, &blk
      end

      # Register code to run when a key is released.
      #
      # Typical text characters are passed to the block as strings.
      # Special keys are identified with symbols. For example :alt_a is the
      # symbol for pressing down the Alt key plus the a key simultaneously.
      #
      # @param [Proc] blk code to when a key is released
      def keyrelease(&blk)
        Shoes::Keyrelease.new @__app__, &blk
      end

      # Run a block in the context of the current slot. Typically used to
      # add more elements into a slot
      def append
        yield if block_given?
      end

      # Change the Shoes application to run the method associated with a passed
      # "url". This typically expects your Shoes app to be defined by deriving
      # from Shoes.
      #
      # The class_book.rb sample is recommended as an example of this approach
      # to Shoes apps.
      #
      # @param [String] url Shoes url to display
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

      # Return the top scrolling location for the main application.
      #
      # Larger values for scroll_top will show positions further down in the
      # application. Smaller values (down to 0) get closer to the top.
      #
      # @return [Fixnum] scroll location
      def scroll_top
        @__app__.scroll_top
      end

      # Set the top scrolling location for the main application.
      #
      # Larger values for scroll_top will show positions further down in the
      # application. Smaller values (down to 0) get closer to the top.
      #
      # @param [Fixnum] n scroll location to set
      def scroll_top=(n)
        @__app__.scroll_top = n
      end

      # Retrieve current clipboard contents.
      #
      # @return [String] current clipboard contents
      def clipboard
        @__app__.clipboard
      end

      # Set the current clipboard contents.
      #
      # @param [String] str clipboard contents
      def clipboard=(str)
        @__app__.clipboard = str
      end

      # Download the contents of a URL.
      #
      # @param [String] name web URL to download
      # @param [Hash] args
      # @param [Proc] blk code to run when download is complete
      # @option args [Proc] :error code to run if the download has an error
      # @option args [Proc] :finish code to run when download is complete
      # @option args [Proc] :progress code to run as download is happening
      # @option args [String] :save filename to write automatically with download contents
      # @option args [String] :body body to send with download request
      # @option args [Hash] :headers HTTP headers to send with download request
      # @option args [String] :method HTTP method for the download request (i.e. GET, POST, etc.)
      def download(name, args = {}, &blk)
        create(Shoes::Download, name, args, &blk).tap(&:start)
      end

      # Width of scrollbar area in pixels.
      #
      # @return [Fixnum] width of scrollbar area in pixels.
      def gutter
        @__app__.gutter
      end
    end
  end
end
