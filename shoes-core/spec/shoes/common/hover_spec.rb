# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Common::Hover do
  include_context "dsl app"

  subject { HoverTest.new(app) }

  before do
    subject.hover { subject.hover_count += 1 }
    subject.leave { subject.leave_count += 1 }
  end

  describe 'hovering' do
    it 'works' do
      subject.mouse_hovered
      expect(subject.hover_count).to eq(1)
    end

    it 'only counts on entry' do
      subject.mouse_hovered
      subject.mouse_hovered
      expect(subject.hover_count).to eq(1)
    end

    it 'counts additional entries' do
      subject.mouse_hovered
      subject.mouse_left
      subject.mouse_hovered
      expect(subject.hover_count).to eq(2)
    end
  end

  describe 'leaving' do
    it "doesn't leave if hasn't hovered first" do
      subject.mouse_left
      expect(subject.leave_count).to eq(0)
    end

    it 'only counts on entry' do
      subject.mouse_hovered
      subject.mouse_left
      expect(subject.leave_count).to eq(1)
    end

    it 'counts additional entries' do
      subject.mouse_hovered
      subject.mouse_left
      subject.mouse_left
      expect(subject.leave_count).to eq(1)
    end
  end

  describe "failure" do
    before do
      subject.hover { raise "hover" }
      subject.leave { raise "leave" }
    end

    describe "by default" do
      it "carries on with hover" do
        expect(Shoes.logger).to receive(:error).with("hover")
        subject.mouse_hovered
      end

      it "carries on with hover" do
        expect(Shoes.logger).to receive(:error).with("hover")
        expect(Shoes.logger).to receive(:error).with("leave")
        subject.mouse_hovered
        subject.mouse_left
      end
    end

    describe "when failing fast" do
      before do
        Shoes.configuration.fail_fast = true
      end

      it "carries on with hover" do
        expect(Shoes.logger).to receive(:error).with("hover")
        expect { subject.mouse_hovered }.to raise_error(RuntimeError)
      end

      it "carries on with hover" do
        expect(Shoes.logger).to receive(:error).with("hover")
        expect(Shoes.logger).to receive(:error).with("leave")
        expect { subject.mouse_hovered }.to raise_error(RuntimeError)
        expect { subject.mouse_left }.to raise_error(RuntimeError)
      end
    end
  end
end

class HoverTest
  include Shoes::Common::SafelyEvaluate
  include Shoes::Common::Hover

  def initialize(app)
    @app = app
    @hover_count = 0
    @leave_count = 0
  end

  attr_accessor :app, :hover_count, :leave_count
end
