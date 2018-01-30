# frozen_string_literal: true

class Shoes
  module DSL
    # DSL methods for adding UI elements in Shoes applications.
    #
    # @see Shoes::DSL
    module Element
      # Creates a border for the current slot.
      #
      # @param [Shoes::Color, Shoes::Gradient, Shoes::ImagePattern] color stroke color, gradient or image pattern to apply
      # @param [Hash] styles
      # @return [Shoes::Border]
      def border(color, styles = {})
        create Shoes::Border, pattern(color), styles
      end

      # Creates a background for the current slot.
      #
      # @param [Shoes::Color, Shoes::Gradient, Shoes::ImagePattern] color background color, gradient or image pattern to apply
      # @param [Hash] styles
      # @return [Shoes::Background]
      def background(color, styles = {})
        create Shoes::Background, pattern(color), style_normalizer.normalize(styles)
      end

      # Creates a single line UI element for entering text.
      #
      # @overload edit_line(text = "", styles = {})
      #   @param [String] text initial text for the edit line
      #   @param [Hash] styles
      #   @option styles [Boolean] secret (false) hides typed characters
      #   @return [Shoes::EditLine]
      def edit_line(*args, &blk)
        style = pop_style(args)
        text  = args.first || ''
        create Shoes::EditLine, text, style, blk
      end

      # Creates a multi-line UI element for entering text.
      #
      # @overload edit_box(text = "", styles = {})
      #   @param [String] text initial text for the edit line
      #   @param [Hash] styles
      #   @return [Shoes::EditBox]
      def edit_box(*args, &blk)
        style = pop_style(args)
        text  = args.first || ''
        create Shoes::EditBox, text, style, blk
      end

      # Creates a progress bar UI element.
      #
      # @param [Hash] opts
      # @option opts [Float] fraction (0.0) progress complete, from 0.0 to 1.0
      # @return [Shoes::Progress]
      def progress(opts = {}, &blk)
        create Shoes::Progress, opts, blk
      end

      # Creates a checkbox UI element.
      #
      # @param [Hash] opts
      # @option opts [Boolean] checked (false) is the box checked?
      # @return [Shoes::Check]
      def check(opts = {}, &blk)
        create Shoes::Check, opts, blk
      end

      # Creates a radio button UI element.
      #
      # @overload radio(group = "", opts = {})
      #   @param [String] group radio group associated with this element
      #   @param [Hash] opts
      #   @option opts [Boolean] checked (false) is the radio selected?
      #   @option opts [String] group ("") associated radio group
      #   @return [Shoes::Radio]
      def radio(*args, &blk)
        style = pop_style(args)
        group = args.first
        create Shoes::Radio, group, style, blk
      end

      # Creates a list box UI element.
      #
      # @param [Hash] opts
      # @option opts [Array] items list of items to show in the list
      # @option opts [String] choose item to select in list
      # @return [Shoes::ListBox]
      def list_box(opts = {}, &blk)
        create Shoes::ListBox, opts, blk
      end

      # Creates a flow container. Flows contain other UI elements, and will
      # line them up until all available width is consumed before wrapping to
      # another line for additional elements.
      #
      # @param [Proc] blk code to place elements inside the flow
      # @param [Hash] opts
      # @option opts [Boolean] scroll whether the flow supports scrolling
      # @return [Shoes::Flow]
      def flow(opts = {}, &blk)
        create Shoes::Flow, opts, blk
      end

      # Creates a stacked container. Stacks contain other UI elements and after
      # each item wraps to a new line.
      #
      # @param [Proc] blk code to place elements inside the stack
      # @param [Hash] opts
      # @option opts [Boolean] scroll whether the stack supports scrolling
      # @return [Shoes::Flow]
      def stack(opts = {}, &blk)
        create Shoes::Stack, opts, blk
      end

      # Creates a clickable button.
      #
      # @param [String] text text to display on the button
      # @param [Proc] blk code to run when the button is clicked
      # @param [Hash] opts
      # @option opts [String] text text to display on the button
      # @option opts [Proc] click code to run when the button is clicked
      # @return [Shoes::Button]
      def button(text = nil, opts = {}, &blk)
        create Shoes::Button, text, opts, blk
      end
    end
  end
end
