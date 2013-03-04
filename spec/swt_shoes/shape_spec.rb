require 'swt_shoes/spec_helper'

describe Shoes::Swt::Shape do
  let(:app) { double("app", add_paint_listener: true) }
  let(:dsl) { double('dsl', hidden: false).as_null_object }
  subject { Shoes::Swt::Shape.new dsl, app }

  shared_examples_for "Swt::Shape" do
    let(:ancestors) { subject.class.ancestors.map(&:name) }

    it "uses Shoes::Swt" do
      ancestors.should include('Shoes::Swt::Shape')
      subject
    end

    it "doesn't use Shoes::Mock" do
      ancestors.should_not include('WhiteShoes::Shape')
      subject
    end

    its(:dsl) { should be(dsl) }
  end

  it_behaves_like "Swt::Shape"
  it_behaves_like "paintable"

  describe "Swt element" do
    let(:element) { double("element") }

    before :each do
      ::Swt::Path.stub(:new) { element }
    end

    it "delegates #move_to" do
      element.should_receive(:move_to).with(20, 30)
      subject.move_to 20, 30
    end

    it "delegates #line_to" do
      element.should_receive(:line_to).with(20, 30)
      subject.line_to 20, 30
    end

    it "delegates #quad_to" do
      element.should_receive(:quad_to).with(100, 100, 20, 200)
      subject.quad_to 100, 100, 20, 200
    end
  end

  describe "moving" do
    let(:transform) { double("transform") }

    before :each do
      ::Swt::Transform.stub(:new) { transform }
    end

    it "delegates #move" do
      transform.should_receive(:translate).with(20, 30)
      subject.move 20, 30
    end

  end

  describe "painter" do
    include_context "painter context"

    let(:shape) { Shoes::Swt::Shape.new(dsl, app) }
    subject { Shoes::Swt::Shape::Painter.new(shape) }

    it_behaves_like "stroke painter"
    it_behaves_like "fill painter"
    it_behaves_like "movable painter"

    it "fills path" do
      gc.should_receive(:fill_path)
      subject.paint_control(event)
    end

    it "draws path" do
      gc.should_receive(:draw_path)
      subject.paint_control(event)
    end
  end
end
