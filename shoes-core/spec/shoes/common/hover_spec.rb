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
