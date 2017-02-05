# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Swt::Common::Resource do
  let(:clazz) do
    Class.new do
      include Shoes::Swt::Common::Resource

      attr_reader :graphic_contexts

      def initialize
        @graphic_contexts = []
      end
    end
  end

  let(:graphic_context) do
    double("gc").tap do |gc|
      expect(gc).to receive(:set_alpha).with(::Shoes::Swt::Common::Resource::OPAQUE)
      expect(gc).to receive(:set_antialias).with(::Swt::SWT::ON)
      expect(gc).to receive(:set_line_cap).with(::Swt::SWT::CAP_FLAT)
      expect(gc).to receive(:set_transform).with(nil)
    end
  end

  subject(:resource) { clazz.new }

  it "tracks graphic contexts" do
    resource.reset_graphics_context(graphic_context)
    expect(resource.graphic_contexts).to eq([graphic_context])
  end

  it "disposes prior graphic contexts" do
    old_context = double("old gc", dispose: nil)
    resource.track_graphics_context(old_context)

    resource.reset_graphics_context(graphic_context)

    expect(old_context).to have_received(:dispose)
    expect(resource.graphic_contexts).to eq([graphic_context])
  end

  describe "clipping" do
    let(:element) { double("element", absolute_left: 0, absolute_top: 0, height: 100, width: 100) }
    let(:clipping) { double("clipping", x: 10, y: 10, height: 50, width: 50) }
    let(:graphic_context) { double("gc", clipping: clipping) }

    it "clips in a block" do
      expect(graphic_context).to receive(:set_clipping).with(0, 0, 100, 100)
      expect(graphic_context).to receive(:set_clipping).with(10, 10, 50, 50)

      resource.clip_context_to(graphic_context, element) do
        @clipped = true
      end

      expect(@clipped).to eq(true)
    end
  end
end
