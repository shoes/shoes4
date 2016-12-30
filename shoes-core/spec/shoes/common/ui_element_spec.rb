require 'spec_helper'

describe Shoes::Common::UIElement do
  include_context "dsl app"

  subject { test_class.new }

  let(:test_class) do
    Class.new do
      include Shoes::Common::UIElement

      # Override UIElement's Initialization include for simpler testing
      def initialize
      end
    end
  end

  describe "stubbed updates" do
    it { is_expected.to respond_to(:update_fill) }
    it { is_expected.to respond_to(:update_stroke) }
  end

  describe "#needs_rotate?" do
    before do
      # Add faux rotate accessor to prove it really doesn't support rotation
      class << subject
        attr_accessor :rotate
      end
    end

    it "doesn't rotate by default" do
      expect(subject.needs_rotate?).to be_falsey
    end

    it "still won't rotate even with a value" do
      subject.rotate = 25
      expect(subject.needs_rotate?).to be_falsey
    end
  end
end
