require 'swt_shoes/spec_helper'

# FIXME: These specs are copied from spec/shoes/element_methods_spec.rb
#        We should run the same specs instead of duplicating.
describe "Basic Element Methods" do
  class ElementMethodsShoeLaces
    include Shoes::ElementMethods

    def initialize(gui)
      @gui = gui
      @app = self
      @style = {}
    end

    attr_reader :gui, :app
  end

  # Doubles for a Shoes::Swt::App
  let(:app_gui) { double('app_gui', real: container) }
  let(:container) { double('container', disposed?: true) }

  # Doubles for a Shoes::App
  let(:app) { ElementMethodsShoeLaces.new app_gui }

  describe "arc" do
    specify "creates a Shoes::Arc" do
      app_gui.should_receive(:add_paint_listener)
      app.stub(:unslotted_elements){ [] }
      app.arc(1, 2, 101, 201, 11, 21).should be_an_instance_of(Shoes::Arc)
    end
  end

  describe "line" do
    specify "creates a Shoes::Line" do
      app_gui.should_receive(:add_paint_listener)
      app.stub(:unslotted_elements){ [] }
      app.line(1, 2, 101, 201).should be_an_instance_of(Shoes::Line)
    end
  end

  describe "oval" do
    specify "creates a Shoes::Oval" do
      app_gui.should_receive(:add_paint_listener)
      app.stub(:unslotted_elements){ [] }
      app.oval(30, 20, 100, 200).should be_an_instance_of(Shoes::Oval)
    end
  end

  describe "shape" do
    subject {
      app.shape do
        move_to 100, 200
        line_to 300, 400
      end
    }

    specify "create a Shoes::Shape" do
      app_gui.should_receive(:add_paint_listener)
      subject.should be_an_instance_of(Shoes::Shape)
    end
  end
end
