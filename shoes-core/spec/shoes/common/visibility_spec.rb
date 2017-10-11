# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Common::Visibility do
  class VisibilityTester
    include Shoes::Common::Visibility
    include Shoes::Common::Style

    attr_reader :gui
    attr_accessor :parent

    def initialize(gui, parent)
      @style = {}
      @gui = gui
      @parent = parent
    end
  end

  subject { VisibilityTester.new(gui, parent) }

  let(:gui)    { double("gui", update_visibility: nil) }
  let(:parent) { double("parent", hidden?: false) }

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
end
