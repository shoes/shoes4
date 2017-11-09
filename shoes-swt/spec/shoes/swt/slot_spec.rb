# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Swt::Slot do
  include_context "swt app"

  let(:dsl) do
    instance_double Shoes::Slot, hidden?: true, visible?: false,
                                 element_right: 100, element_top: 0,
                                 element_height: 100,
                                 scroll: true, scroll_top: 0,
                                 contents: [content]
  end

  let(:scroll) do
    double 'scroll', add_selection_listener: nil,
                     set_visible: nil, set_bounds: nil,
                     'selection=': nil, 'maximum=': nil
  end

  let(:content) { double 'content', show: true, hide: true }

  subject { Shoes::Swt::Slot.new dsl, swt_app }

  before do
    allow(::Swt::Widgets::Slider).to receive(:new).and_return(scroll)
  end

  describe '#remove' do
    it 'cleans up click listeners' do
      expect(swt_app.click_listener).to receive(:remove_listeners_for).with(dsl)
      subject.remove
    end
  end

  it "updates scroll position on dsl" do
    allow(scroll).to receive(:selection).and_return(10)
    expect(dsl).to receive(:scroll_top=).with(10)
    subject.update_scroll
  end

  it "sets scrolling position based on dsl" do
    allow(dsl).to receive(:scroll_max).and_return(100)
    allow(dsl).to receive(:scroll_top).and_return(75)
    expect(scroll).to receive(:selection=).with(75)
    subject.update_visibility
  end

  it "sets scrolling maximum based on dsl with padding" do
    allow(dsl).to receive(:scroll_max).and_return(100)
    expect(scroll).to receive(:maximum=).with(110)
    subject.update_visibility
  end

  describe "scroll visibility" do
    it "hides when isn't scrolling" do
      allow(dsl).to receive(:scroll).and_return(false)
      expect(scroll).to receive(:set_visible).with(false)
      subject.update_visibility
    end

    it "hides when doesn't have scrolled content" do
      allow(dsl).to receive(:scroll_max).and_return(0)
      expect(scroll).to receive(:set_visible).with(false)
      subject.update_visibility
    end

    it "shows when there's stuff scrolled off" do
      allow(dsl).to receive(:scroll_max).and_return(100)
      expect(scroll).to receive(:set_visible).with(true)
      subject.update_visibility
    end
  end

  it "sets scrolling size from dsl" do
    allow(dsl).to receive(:scroll_max).and_return(100)
    expect(scroll).to receive(:set_bounds).with(81, 0, 20, 100)
    subject.update_visibility
  end
end
