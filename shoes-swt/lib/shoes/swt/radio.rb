# frozen_string_literal: true

class Shoes
  module Swt
    # In Swt a radio button is actually just a
    # button, so a lot of these methods are
    # borrowed from button.rb
    class Radio < CheckButton
      attr_reader :group

      # Create a radio button
      #
      # @param [Shoes::Radio] dsl The Shoes DSL radio this represents
      # @param [::Swt::Widgets::Composite] app The app element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, app)
        super(dsl, app, ::Swt::SWT::RADIO)
        self.group = dsl.group
      end

      def group=(value)
        group_lookup = RadioGroup.group_lookup
        group_lookup[group].remove(self) unless group.nil?
        @group = value || RadioGroup::DEFAULT_RADIO_GROUP
        group_lookup[group].add self
      end
    end
  end
end
