# frozen_string_literal: true

class Shoes
  class Slot < Common::UIElement
    include Common::Clickable
    include Common::Hover

    # We need that offset because otherwise element overlap e.g. occupy
    # the same pixel - this way they start right next to each other
    # See #update_current_position
    NEXT_ELEMENT_OFFSET = 1

    attr_reader :parent, :dimensions, :gui, :contents, :blk

    attr_reader :scroll_top
    attr_accessor :scroll_height

    style_with :art_styles, :attach, :common_styles, :dimensions, :scroll
    STYLES = { scroll: false, fill: Shoes::COLORS[:black] }.freeze

    def create_dimensions(*args)
      super(*args)

      @fixed_height = !height.nil?
      @scroll_top   = 0
      set_default_dimension_values
      @pass_coordinates = true
    end

    def before_initialize(*_)
      @contents = SlotContents.new
      @last_hidden_state = nil
    end

    def handle_block(blk)
      snapshot_current_position

      @blk = blk
      eval_block blk
    end

    def snapshot_current_position
      top = element_top - scroll_offset
      @current_position = Position.new element_left, top, top
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

    def remove
      clear
      super
    end

    def eval_block(blk, *args)
      old_current_slot = @app.current_slot
      @app.current_slot = self
      safely_evaluate(*args, &blk)
      @app.current_slot = old_current_slot
    end

    def create_bound_block(blk)
      proc do |*args|
        eval_block(blk, *args)
      end
    end

    def add_child(element)
      contents.add_element element

      return if element.hidden? || !element.takes_up_space?

      # Prepending would entail repositioning everyone after us, so just give
      # it up and let contents_alignment save us the work.
      if contents.prepending?
        contents_alignment
      else
        original_height = self.height
        @current_position = positioning(element, @current_position)

        height_delta = slot_grew_by(original_height)
        bump_parent_current_position(height_delta)
      end
    end

    def slot_grew_by(original_height)
      determine_slot_height
      self.height - original_height
    end

    def bump_parent_current_position(height_delta)
      return unless height_delta.positive?
      return unless parent.respond_to?(:bump_current_position)

      parent.bump_current_position(self, height_delta)
    end

    # This method gets called when one of our child slots got larger, so we
    # need to move our current position to accomodate.
    def bump_current_position(growing_slot, height_delta)
      # If intermediate child changed, give up and hit it with the big hammer
      if any_sibling_slots_following?(growing_slot)
        contents_alignment
      else
        @current_position.y += height_delta
        @current_position.next_line_start += height_delta
      end
    end

    def any_sibling_slots_following?(growing_slot)
      next_sibling  = contents.index(growing_slot) + 1
      next_siblings = contents[next_sibling..-1]
      next_siblings.any? { |e| e.is_a?(Slot) }
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

    def contents_alignment(_ = nil)
      position_contents
      update_child_visibility

      # Layout code expects height returned!
      determine_slot_height
    end

    def add_mouse_hover_control
      @app.add_mouse_hover_control(self)
    end

    def scroll_top=(value)
      unless scroll
        Shoes.logger.warn "You've set scroll_top on a slot (#<#{self.class}:0x#{hash.to_s(16)}...>) that isn't scrollable. This will be ignored."
        return
      end

      value = 0 if value.negative?
      @scroll_top = [value, scroll_max].min
    end

    def scroll_max
      contents_alignment
      return 0 unless scroll_height && height

      [scroll_height - height, 0].max
    end

    def app
      @app.app # return the Shoes::App not the internal app
    end

    def inspect
      "#<#{self.class}:0x#{hash.to_s(16)} @contents=#{@contents.inspect} and so much stuff literally breaks the memory limit. Look at it selectively.>"
    end

    def fixed_height?
      @fixed_height
    end

    def variable_height?
      !@fixed_height
    end

    protected

    Position = Struct.new(:x, :y, :next_line_start)

    def position_contents
      snapshot_current_position

      contents.each do |element|
        next if element.hidden?
        @current_position = positioning(element, @current_position)
      end

      @current_position
    end

    def positioning(element, current_position)
      if element.needs_positioning?
        align_position = if element.attached_to
                           position_attached_element(element)
                         else
                           position_slotted_element(element, current_position)
                         end

        element.contents_alignment(align_position) if element.respond_to?(:contents_alignment)
      end

      update_current_position(current_position, element)
    rescue => e
      raise e if ENV['SHOES_ENV'] == 'test'

      puts "SWALLOWED POSITIONING EXCEPTION ON #{element} - go take care of it: " + e.to_s
      puts e.backtrace.join("\n\t")
      puts 'Unfortunately we have to swallow it or risk SWT hanging.'
      puts "It doesn't like exceptions during layout. :O"

      current_position
    end

    def position_element(_element, _current_position)
      raise 'position_element is a subclass responsibility'
    end

    def position_attached_element(element)
      attached_left = element.attached_to.absolute_left + element.style[:left].to_i
      attached_top  = element.attached_to.absolute_top + element.style[:top].to_i

      position_element_at element, attached_left, attached_top

      Position.new attached_left, attached_top, attached_top
    end

    def position_slotted_element(element, current_position)
      position_element element, current_position
      current_position
    end

    def position_in_current_line(element, current_position)
      position_element_at element,
                          position_x(current_position.x, element),
                          position_y(current_position.y, element)
    end

    def move_to_next_line(element, current_position)
      position_element_at element,
                          position_x(element_left, element),
                          position_y(current_position.next_line_start, element)
    end

    def position_element_at(element, x, y)
      return if element_did_not_move?(element, x, y)
      element._position x, y
    end

    def element_did_not_move?(element, x, y)
      element.absolute_left == x && element.absolute_top == y
    end

    def should_update_current_position?(element)
      !element.attached_to &&
        !element.absolutely_positioned? &&
        element.takes_up_space?
    end

    def update_current_position(current_position, element)
      return current_position unless should_update_current_position?(element)

      current_position.x = element.absolute_right + NEXT_ELEMENT_OFFSET
      current_position.y = element.absolute_top
      next_element_line_start = next_line_start_from element

      if current_position.next_line_start < next_element_line_start
        current_position.next_line_start = next_element_line_start
      end

      element.adjust_current_position current_position
      current_position
    end

    def next_line_start_from(element)
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
        element_left + element.left
      elsif element.absolute_right_position?
        element_right - (element.right + element.width)
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
        element_top + element.top
      elsif element.absolute_bottom_position?
        # TODO: slots grow... to really position it relative to the bottom
        # we probably need to position it after everything has been positioned
        element_bottom - (element.bottom + element.height)
      end
    end

    def fits_on_the_same_line?(element, current_x)
      fitting_width = element.width
      fitting_width = element.fitting_width if element.respond_to?(:fitting_width)
      current_x + fitting_width - 1 <= element_right
    end

    def determine_slot_height
      content_height = compute_content_height
      self.scroll_height = content_height
      self.element_height = content_height if variable_height?
      content_height
    end

    def compute_content_height
      max_bottom = contents
                   .select(&:takes_up_space?)
                   .reject(&:hidden?)
                   .map(&:absolute_bottom)
                   .max

      if max_bottom
        max_bottom - (element_top - scroll_offset) + NEXT_ELEMENT_OFFSET
      else
        0
      end
    end

    def update_visibility
      # Always update our backend via common implementation
      super

      # Only alter contents on a visibility change
      if @last_hidden_state != hidden?
        @last_hidden_state = hidden?
        update_child_visibility
      end

      self
    end

    def update_child_visibility
      contents.each(&:update_visibility)
    end

    def scroll_offset
      scroll ? @scroll_top : 0
    end
  end

  class Flow < Slot
    # Included to generate the *Hover class
    include Common::Hover

    def position_element(element, current_position)
      if fits_on_the_same_line?(element, current_position.x)
        position_in_current_line(element, current_position)
      else
        move_to_next_line(element, current_position)
      end
    end
  end

  class Stack < Slot
    # Included to generate the *Hover class
    include Common::Hover

    def position_element(element, current_position)
      move_to_next_line(element, current_position)
    end
  end
end
