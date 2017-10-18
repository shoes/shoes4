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
    it 'must call #focus on gui' do
      expect(gui).to receive(:focus)
      subject.focus
    end
  end

  describe "#focused?" do
    it 'must call #focused? on gui' do
      expect(gui).to receive(:focused?)
      subject.focused?
    end

    it "has alias #focused" do
      expect(subject.method(:focused) == subject.method(:focused?)).to be true
    end

    it "has alias #focussed" do
      expect(subject.method(:focussed) == subject.method(:focused?)).to be true
    end

    it "has alias #focussed" do
      expect(subject.method(:focussed?) == subject.method(:focused?)).to be true
    end
  end
end
