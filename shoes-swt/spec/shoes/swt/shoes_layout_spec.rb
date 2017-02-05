# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Swt::ShoesLayout do
  subject do
    result = Shoes::Swt::ShoesLayout.new
    result.gui_app = gui_app
    result
  end

  let(:gui_app)   { double('gui_app', dsl: dsl, real: real, shell: shell) }
  let(:size)      { double('size', height: 0, width: 0) }
  let(:location)  { double('location', :y= => nil) }
  let(:dsl)       { double('dsl', top_slot: top_slot, height: 100, width: 100) }
  let(:shell)     { double('shell', vertical_bar: vertical_bar) }

  let(:scroll_height) { dsl.height * 2 }

  let(:real) do
    double('real', set_size: nil, location: location, :location= => nil)
  end

  let(:top_slot) do
    double('top_slot', contents_alignment: 0, :width= => nil, :height= => nil)
  end

  let(:vertical_bar) do
    double('vertical_bar', :increment= => nil, :visible= => nil,
                           :maximum= => nil, :thumb= => nil, thumb: 0)
  end

  before do
    allow(real).to receive(:compute_trim) do |_, _, width, height|
      double('size', width: width, height: height)
    end
  end

  it "sets size on real element" do
    expect(real).to receive(:set_size).with(dsl.width, dsl.height)
    subject.layout
  end

  it "sets height on real element to scrollable height when that's bigger" do
    when_contents_scroll
    expect(real).to receive(:set_size).with(dsl.width, scroll_height)
    subject.layout
  end

  it "sets size on top slot" do
    expect(top_slot).to receive(:width=).with(dsl.width)
    expect(top_slot).to receive(:height=).with(dsl.height)
    subject.layout
  end

  it "sets height on top slot to scrollable height when that's bigger" do
    when_contents_scroll
    expect(top_slot).to receive(:width=).with(dsl.width)
    expect(top_slot).to receive(:height=).with(scroll_height)
    subject.layout
  end

  it "shows scrollbar" do
    when_contents_scroll
    expect(vertical_bar).to receive(:visible=).with(true)
    subject.layout
  end

  it "updates settings on scrollbar when visible" do
    when_contents_scroll
    [:thumb=, :maximum=, :increment=].each do |m|
      expect(vertical_bar).to receive(m)
    end
    subject.layout
  end

  it "hides scrollbar" do
    expect(vertical_bar).to receive(:visible=).with(false)
    subject.layout
  end

  it "sets gui location when scrollbar hidden" do
    expect(real).to receive(:location=).with(location)
    subject.layout
  end

  def when_contents_scroll
    allow(top_slot).to receive(:contents_alignment) { scroll_height }
  end
end
