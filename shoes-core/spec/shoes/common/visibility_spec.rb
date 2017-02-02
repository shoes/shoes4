require 'spec_helper'

describe Shoes::Common::Visibility do
  class VisibilityTester
    include Shoes::Common::Visibility
    include Shoes::Common::Style

    attr_reader :gui

    def initialize(gui)
      @style = {}
      @gui = gui
    end
  end

  subject { VisibilityTester.new(gui) }

  let(:gui) { double("gui", update_visibility: nil) }

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

  it "shows" do
    subject.show
    expect(subject.style[:hidden]).to eq(false)

    subject.toggle
    expect(subject.style[:hidden]).to eq(true)
  end

  it "is hidden?" do
    subject.hide
    expect(subject).to be_hidden
  end

  it "is visible?" do
    subject.show
    expect(subject).to be_visible
  end
end
