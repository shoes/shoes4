class Shoes
  class Slot
    include Common::UIElement
    include Common::Clickable
    include Common::Style

    # We need that offset because otherwise element overlap e.g. occupy
    # the same pixel - this way they start right next to each other
    # See #update_current_position
    NEXT_ELEMENT_OFFSET = 1

    attr_reader :parent, :gui, :contents, :blk, :dimensions, :hover_proc,
                :leave_proc, :scroll
    style_with :art_styles, :attach, :dimensions, :stroke

    def initialize(app, parent, styles = {}, blk = nil)
      init_attributes(app, parent, styles, blk)
      @parent.add_child self

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      eval_block blk
      contents_alignment
    end

    def init_attributes(app, parent, styles, blk)
      @app            = app
      @parent         = parent
      @contents       = SlotContents.new
      @blk            = blk
      style_init(styles)

      @dimensions     = Dimensions.new parent, @style
      @fixed_height   = height || false
      @scroll         = styles.fetch(:scroll, false)
      @scroll_top     = 0
      set_default_dimension_values

      @pass_coordinates = true
    end

    def set_default_dimension_values
      self.width          ||= 1.0
      self.height         ||= 0
      self.absolute_left  ||= 0
      self.absolute_top   ||= 0
    end

    def clear(&blk)
      contents.clear
      eval_block blk
    end

    def eval_block blk
      old_current_slot = @app.current_slot
      @app.current_slot = self
      blk.call if blk
      @app.current_slot = old_current_slot
    end

    def add_child(element)
      contents.add_element element
    end

    def remove_child(element)
      contents.delete element
    end

    def append(&blk)
      eval_block blk
    end

    def prepend(&blk)
      contents.prepend do
        eval_block blk
      end
    end

    def contents_alignment(_=nil)
      position_contents
      determine_slot_height
    end

    def hovered?
      @hovered
    end

    def hover(blk)
      @hover_proc = blk
      @app.add_mouse_hover_control self
    end

    def leave(blk)
      @leave_proc = blk
      @app.add_mouse_hover_control self
    end

    def mouse_hovered
      @hovered = true
      @hover_proc.call(self) if @hover_proc
    end

    def mouse_left
      @hovered = false
      @leave_proc.call(self) if @leave_proc
    end

    def scroll_height
      position_contents.y
    end

    def scroll_max
      scroll_height - height
    end

    def scroll_top
      @scroll_top
    end

    def scroll_top=(position)
      @scroll_top = position
    end

    def app
      @app.app #return the Shoes::App not the internal app
    end

    def inspect
      "#<#{self.class}:0x#{hash.to_s(16)} @contents=#{@contents.inspect} and so much stuff literally breaks the memory limit. Look at it selectively.>"
    end

    protected
    CurrentPosition = Struct.new(:x, :y, :next_line_start)

    def position_contents
      current_position = CurrentPosition.new element_left,
                                             element_top,
                                             element_top

      contents.each do |element|
        next if element.hidden?
        current_position = positioning(element, current_position)
      end
      current_position
    end

    def positioning(element, current_position)
      return current_position unless element.needs_to_be_positioned?
      position_element element, current_position
      element.contents_alignment(current_position) if element.respond_to? :contents_alignment
      if element.takes_up_space?
        update_current_position(current_position, element)
      else
        current_position
      end
    end

    def position_element(element, current_position)
      raise 'position_element is a subclass responsibility'
    end

    def position_in_current_line(element, current_position)
      position_element_at element,
                          position_x(current_position.x, element),
                          position_y(current_position.y, element)
    end

    def move_to_next_line(element, current_position)
      position_element_at element,
                          position_x(self.element_left, element),
                          position_y(current_position.next_line_start, element)
    end

    def position_element_at(element, x, y)
      return if element_did_not_move?(element, x, y)
      element._position x, y
    end

    def element_did_not_move?(element, x, y)
      element.absolute_left == x && element.absolute_top == y
    end

    def update_current_position(current_position, element)
      return current_position if element.absolutely_positioned?
      current_position.x = element.absolute_right + NEXT_ELEMENT_OFFSET
      current_position.y = element.absolute_top
      next_element_line_start = next_line_start_from element
      if current_position.next_line_start < next_element_line_start
        current_position.next_line_start = next_element_line_start
      end
      element.adjust_current_position current_position
      current_position
    end

    def next_line_start_from element
      element.absolute_bottom + NEXT_ELEMENT_OFFSET
    end

    def position_x(relative_x, element)
      if element.absolute_x_position?
        absolute_x_position(element)
      else
        relative_x
      end
    end

    def absolute_x_position(element)
      if element.absolute_left_position?
        self.absolute_left + element.left
      elsif element.absolute_right_position?
        self.absolute_right - (element.right + element.width)
      end
    end

    def position_y(relative_y, element)
      if element.absolute_y_position?
        absolute_y_position(element)
      else
        relative_y
      end
    end

    def absolute_y_position(element)
      if element.absolute_top_position?
        self.absolute_top + element.top
      elsif element.absolute_bottom_position?
        # TODO: slots grow... to really position it relative to the bottom
        # we probably need to position it after everything has been positioned
        self.absolute_bottom - (element.bottom + element.height)
      end
    end

    def fits_on_the_same_line?(element, current_x)
      fitting_width = element.width
      fitting_width = element.fitting_width if element.respond_to?(:fitting_width)
      current_x + fitting_width - 1 <= element_right
    end

    def determine_slot_height
      content_height = compute_content_height
      self.height = content_height if has_variable_height?
      content_height
    end

    def compute_content_height
      max_bottom = contents.reject(&:hidden?).
                            map(&:absolute_bottom).
                            max
      if max_bottom
        max_bottom - self.absolute_top + NEXT_ELEMENT_OFFSET
      else
        0
      end
    end

    def has_variable_height?
      not @fixed_height
    end
  end

  class Flow < Slot
    def position_element(element, current_position)
      if fits_on_the_same_line?(element, current_position.x)
        position_in_current_line(element, current_position)
      else
        move_to_next_line(element, current_position)
      end
    end
  end

  class Stack < Slot
    def position_element(element, current_position)
      move_to_next_line(element, current_position)
    end
  end
end
