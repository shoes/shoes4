# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Common::Clickable do
  include_context "dsl app"

  class ClickTester < Shoes::Common::UIElement
    include Shoes::Common::Clickable

    style_with :click

    def create_dimensions
      # Patched to avoid ratholing on shared setup we don't care about here
      nil
    end
  end

  subject { ClickTester.new(app, parent) }

  before do
    allow(Shoes).to receive(:backend_for).and_return(gui)
  end

  let(:gui)    { double("gui", update_visibility: nil) }
  let(:parent) { double("parent", add_child: nil) }
  let(:block)  { proc {} }

  it "clicks" do
    expect(gui).to receive(:click).with(block)
    subject.click(&block)
  end

  it "clicks with style" do
    expect(gui).to receive(:click).with(block)
    subject.style(click: block)
  end

  it "clicks from styles at initialization" do
    expect(gui).to receive(:click).with(block)
    ClickTester.new(app, parent, click: block)
  end

  it "clicks from initialize block by default" do
    expect(gui).to receive(:click).with(block)
    ClickTester.new(app, parent, block)
  end
end
