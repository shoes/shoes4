require 'swt_shoes/spec_helper'

describe Shoes::Swt::Shape do
  let(:app) { double("app") }
  let(:gui_element) { double('gui element') }
  let(:args_with_element) { {app: app, element: gui_element} }
  let(:args_without_element) { {app: app} }

  let(:dsl) { double('dsl').as_null_object }

  shared_examples_for "Swt::Shape" do
    before :each do
      app.should_receive(:add_paint_listener)
    end

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

  context "with app and gui element" do
    subject { Shoes::Swt::Shape.new dsl, args_with_element }

    it_behaves_like "Swt::Shape"
    it_behaves_like "paintable"
  end

  context "with app only" do
    subject { Shoes::Swt::Shape.new dsl, args_without_element }

    it_behaves_like "Swt::Shape"
    it_behaves_like "paintable"

    describe "#initialize" do
      before :each do
        app.should_receive(:add_paint_listener)
      end

      it "should not set current point on gui element" do
        gui_element.should_not_receive(:move_to)
        subject
      end
    end
  end

  describe "painter" do
    include_context "painter context"

    subject { Shoes::Swt::Shape::Painter.new(shape) }

    it_behaves_like "stroke painter"
    it_behaves_like "fill painter"

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
