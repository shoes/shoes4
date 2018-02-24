# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Common::Focus do
  class FocusTester
    include Shoes::Common::Focus

    attr_reader :gui

    def initialize(gui)
      @gui = gui
    end
  end

  subject { FocusTester.new(gui) }

  let(:gui) { double("gui", update_visibility: nil) }

  describe "#focus" do
    before do
      expect(gui).to receive(:focus)
    end

    it 'calls #focus on gui' do
      subject.focus
    end

    it 'returns the element' do
      returned = subject.focus
      expect(returned).to eq(subject)
    end
  end

  describe "#focused?" do
    it 'must call #focused? on gui' do
      expect(gui).to receive(:focused?)
      subject.focused?
    end

    it "has alias #focused" do
      expect(subject.method(:focused)).to eq(subject.method(:focused?))
    end

    it "has alias #focussed" do
      expect(subject.method(:focussed)).to eq(subject.method(:focused?))
    end

    it "has alias #focussed" do
      expect(subject.method(:focussed?)).to eq(subject.method(:focused?))
    end
  end
end
