class Shoes
  module Swt
    # In Swt a radio button is actually just a
    # button, so a lot of these methods are
    # borrowed from button.rb
    class Radio < CheckButton
      @@radio_groups = {}

      # Create a radio button
      #
      # @param [Shoes::Radio] dsl The Shoes DSL radio this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent)
        super(dsl, parent, ::Swt::SWT::RADIO)

        group = dsl.group || RadioGroup::DEFAULT_RADIO_GROUP
        @@radio_groups[group] ||= RadioGroup.new(group)
        @@radio_groups[group].add self
      end
    end
  end
end


