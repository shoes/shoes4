# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Common::Visibility do
  class VisibilityTester
    include Shoes::Common::Visibility
    include Shoes::Common::Style

    attr_reader :dimensions, :gui
    attr_accessor :painted, :parent

    def initialize(gui, parent)
      @gui = gui
      @painted = false
      @parent = parent

      @dimensions = Shoes::Dimensions.new(nil, 0, 0, 0, 0)
      @style = {}
    end

    def painted?
      @painted
    end
  end

  subject { VisibilityTester.new(gui, parent) }

  let(:gui)    { double("gui", update_visibility: nil) }
  let(:parent) { double("parent", hidden?: false, variable_height?: false) }

  it "hides" do
    subject.hide
    expect(subject.style[:hidden]).to eq(true)
    expect(subject.gui).to have_received(:update_visibility)
  end

  it "shows" do
    subject.show
    expect(subject.style[:hidden]).to eq(false)
    expect(subject.gui).to have_received(:update_visibility)
  end

  it "toggles" do
    subject.show
    expect(subject.style[:hidden]).to eq(false)

    subject.toggle
    expect(subject.style[:hidden]).to eq(true)
  end

  it "chains" do
    expect(subject.hide).to eq(subject)
    expect(subject.show).to eq(subject)
    expect(subject.toggle).to eq(subject)
  end

  it "is hidden?" do
    subject.hide
    expect(subject).to be_hidden
  end

  it "is visible?" do
    subject.show
    expect(subject).to be_visible
  end

  it "hides when parent hides" do
    allow(parent).to receive(:hidden?).and_return(true)
    expect(subject).to be_hidden
  end

  it "doesn't change local hidden state because of parent" do
    allow(parent).to receive(:hidden?).and_return(true)
    expect(subject.style[:hidden]).to be_falsey
  end

  it "allows parent to be missing" do
    allow(parent).to receive(:hidden?).and_return(true)
    subject.parent = nil
    expect(subject).to be_visible
  end

  describe "view checking" do
    before do
      subject.show
    end

    it "is not hidden from view if no parent" do
      subject.parent = nil
      expect(subject.hidden_from_view?).to eq(false)
    end

    it "is not hidden from view if variable height parent" do
      allow(parent).to receive(:variable_height?).and_return(true)
      expect(subject.hidden_from_view?).to eq(false)
    end

    it "is not hidden from view if painted" do
      subject.painted = true
      expect(subject.hidden_from_view?).to eq(false)
    end

    it "is not hidden from view if within parent" do
      allow(parent).to receive(:contains?).and_return(true)
      expect(subject.hidden?).to eq(false)
      expect(subject.hidden_from_view?).to eq(false)
    end

    it "is hidden from view if outside parent" do
      allow(parent).to receive(:contains?).and_return(false)
      expect(subject.hidden?).to eq(false)
      expect(subject.hidden_from_view?).to eq(true)
    end
  end
end
