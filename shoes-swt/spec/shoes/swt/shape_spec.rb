# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Swt::Shape do
  include_context "swt app"

  let(:dsl) do
    double("Shoes::Shape", hidden: false, needs_rotate?: false,
                           translate_left: 0, translate_top: 0,
                           style: {}).as_null_object
  end

  subject { Shoes::Swt::Shape.new dsl, swt_app }

  shared_examples_for "Swt::Shape" do
    let(:ancestors) { subject.class.ancestors.map(&:name) }

    it "uses Shoes::Swt" do
      expect(ancestors).to include('Shoes::Swt::Shape')
      subject
    end

    its(:dsl) { is_expected.to be(dsl) }
  end

  it_behaves_like "Swt::Shape"
  it_behaves_like "paintable"
  it_behaves_like "removable"
  it_behaves_like 'clickable backend'

  it "properly disposes" do
    expect(subject.transform).to receive(:dispose)
    expect(subject.element).to receive(:dispose)
    subject.dispose
  end

  describe "Swt element" do
    let(:element) { double("element") }

    before :each do
      allow(::Swt::Path).to receive(:new) { element }
    end

    it "delegates #move_to" do
      expect(element).to receive(:move_to).with(20, 30)
      subject.move_to 20, 30
    end

    it "delegates #line_to" do
      expect(element).to receive(:line_to).with(20, 30)
      subject.line_to 20, 30
    end

    it "delegates #arc_to" do
      expect(element).to receive(:add_arc).with(25, 45, 50, 20, 0.0, -90.0)
      subject.arc_to 50, 55, 50, 20, 0, Shoes::PI / 2
    end
  end

  describe "moving" do
    let(:transform) { double("transform") }

    before :each do
      allow(::Swt::Transform).to receive(:new) { transform }
    end

    it "translates position to dsl's element_left and element_top" do
      allow(dsl).to receive(:element_left) { 20 }
      allow(dsl).to receive(:element_top) { 30 }
      expect(transform).to receive(:translate).with(20, 30)
      subject.update_position
    end
  end
end
