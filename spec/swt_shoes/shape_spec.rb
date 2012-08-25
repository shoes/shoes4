require 'swt_shoes/spec_helper'

describe Shoes::Swt::Shape do
  let(:gui_container_real) { double("gui container real") }
  let(:gui_container) { double("gui container", real: gui_container_real) }
  let(:container) { double("container", gui: gui_container)  }
  let(:gui_element) { double('gui element') }
  let(:args_with_element) { {app: container, element: gui_element} }
  let(:args_without_element) { {app: container} }

  let(:dsl) { double('dsl').as_null_object }

  shared_examples_for "Swt::Shape" do
    before :each do
      gui_container_real.should_receive(:add_paint_listener)
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

    it "sets container" do
      subject.container.should be(gui_container_real)
    end

    its(:dsl) { should be(dsl) }
  end

  context "with gui container and gui element" do
    subject { Shoes::Swt::Shape.new dsl, args_with_element }

    it_behaves_like "Swt::Shape"
    it_behaves_like "paintable"
  end

  context "with gui container only" do
    subject { Shoes::Swt::Shape.new dsl, args_without_element }

    it_behaves_like "Swt::Shape"
    it_behaves_like "paintable"

    describe "#initialize" do
      before :each do
        gui_container_real.should_receive(:add_paint_listener)
      end

      it "should not set current point on gui element" do
        gui_element.should_not_receive(:move_to)
        subject
      end
    end
  end

  context "painter" do
    include_context "paintable context"
    include_context "minimal painter context"

    let(:shape) { double("shape").as_null_object }
    subject { Shoes::Swt::Shape::Painter.new(shape) }
    #subject {
      #Shoes::Swt::Shape.new(dsl, args_without_element) {
        #move_to 150, 150
        #line_to 300, 300
        #line_to 0, 300
        #line to 150, 350
      #}
    #}

    #it_behaves_like "Swt object with stroke"
    #it_behaves_like "Swt object with fill"
    it_behaves_like "swt stroke"
    it_behaves_like "swt fill"
  end
end
