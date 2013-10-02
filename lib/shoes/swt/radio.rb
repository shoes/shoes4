class Shoes
  module Swt
    # In Swt a radio button is actually just a
    # button, so a lot of these methods are
    # borrowed from button.rb
    class Radio < CheckButton
      attr_accessor :group

      # Create a radio button
      #
      # @param [Shoes::Radio] dsl The Shoes DSL radio this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent)
        super(dsl, parent, ::Swt::SWT::RADIO)
        self.group = dsl.group
      end

      def group=(value)
        all_groups = RadioGroup::all_groups
        all_groups[@group].remove(self) unless @group.nil?
        @group = value || RadioGroup::DEFAULT_RADIO_GROUP
        all_groups[@group].add self
      end

      def dump_all_radio_groups(all_groups)
        puts "ALL RADIO GROUPS"
        puts "----------------"
        all_groups.each do |key, grp|
          puts "Group Name: #{key}"
          grp.each do |rad|
            puts "  #{rad}"
          end
        end
      end
    end
  end
end


