require 'swt_shoes/spec_helper'

describe Shoes::Swt::Common::Remove do
  let(:clazz)  {
    Class.new do
      include Shoes::Swt::Common::Remove

      attr_reader :app, :real, :dsl

      def initialize(app, dsl, real = nil)
        @app = app
        @dsl = dsl
        @real = real
      end
    end
  }

  let(:app)  { double("app", clickable_elements: clickable_elements) }
  let(:dsl)  { double("dsl") }
  let(:clickable_elements) { [dsl] }

  subject { clazz.new(app, dsl) }

  before do
    expect(app).to receive(:remove_paint_listener)
    expect(app).to receive(:remove_listener).at_least(:once)
  end

  describe "remove" do
    it "cleans up clickable element" do
      subject.remove
      expect(clickable_elements).to be_empty
    end
  end

  describe "real disposal" do
    let(:real) { double("real") }

    subject { clazz.new(app, dsl, real) }

    it "disposes of real if present" do
      allow(real).to receive(:disposed?) { false }
      expect(real).to receive(:dispose)
      subject.remove
    end

    it "doesn't dispose if already done!" do
      allow(real).to receive(:disposed?) { true }
      expect(real).to_not receive(:dispose)
      subject.remove
    end
  end
end
