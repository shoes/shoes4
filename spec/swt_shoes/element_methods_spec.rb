require 'swt_shoes/spec_helper'

# FIXME: These specs are copied from spec/shoes/element_methods_spec.rb
#        We should run the same specs instead of duplicating.
describe "Basic Element Methods" do
  class ElementMethodsShoeLaces
    attr_accessor :gui_container
    include Shoes::ElementMethods
    include Shoes::Swt::ElementMethods
    def initialize
      @style = {}
    end
  end

  let(:gui_container) { double('gui_container') }
  let(:app) {
    ElementMethodsShoeLaces.new.tap { |a|
      a.gui_container = gui_container
    }
  }

  describe "line" do
    specify "creates a Shoes::Line" do
      gui_container.should_receive(:add_paint_listener)
      app.line(1, 2, 101, 201).should be_an_instance_of(Shoes::Line)
    end
  end

  describe "oval" do
    # The oval object
    subject { app.oval(30, 20, 100, 200) }
    context "Swt-specific" do
    end

    it_behaves_like "paintable"
  end

  describe "shape" do
    subject {
      app.shape do
        move_to 100, 200
        line_to 300, 400
      end
    }

    specify "create a Shoes::Shape" do
      gui_container.should_receive(:add_paint_listener)
      subject.should be_an_instance_of(Shoes::Shape)
    end
  end

end
