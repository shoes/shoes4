require 'swt_shoes/spec_helper'

# FIXME: These specs are copied from spec/shoes/element_methods_spec.rb
#        We should run the same specs instead of duplicating.
describe "Basic Element Methods" do
  class DSLShoeLaces
    include Shoes::DSL

    def initialize(gui)
      @gui = gui
      @app = self
      @style = {}
    end

    attr_reader :gui, :app
  end

  # Doubles for a Shoes::Swt::App
  let(:app_gui) { double('app_gui', real: container, dsl: dsl) }
  let(:container) { double('container', disposed?: true) }
  let(:dsl) { double('dsl', rotate: 0 ) }

  # Doubles for a Shoes::App
  let(:app) { DSLShoeLaces.new app_gui }

  describe "arc" do
    specify "creates a Shoes::Arc" do
      app_gui.should_receive(:add_paint_listener)
      app.stub(:unslotted_elements){ [] }
      app.arc(1, 2, 101, 201, 11, 21).should be_an_instance_of(Shoes::Arc)
    end

    specify "raises an ArgumentError" do
      app.stub(:unslotted_elements){ [] }
      lambda { app.arc(30) }.should raise_exception(ArgumentError)
    end
  end

  describe "rect" do
    specify "creates a Shoes::Rect" do
      app_gui.should_receive(:add_paint_listener)
      app.stub(:unslotted_elements){ [] }
      app.rect(10, 20, 10, 20, angle: 45).should be_an_instance_of(Shoes::Rect)
    end

    specify "raises an ArgumentError" do
      app.stub(:unslotted_elements){ [] }
      lambda { app.rect(30) }.should raise_exception(ArgumentError)
    end
  end

  describe "line" do
    specify "creates a Shoes::Line" do
      app_gui.should_receive(:add_paint_listener)
      app.stub(:unslotted_elements){ [] }
      app.line(1, 2, 101, 201).should be_an_instance_of(Shoes::Line)
    end

    specify "raises an ArgumentError" do
      app.stub(:unslotted_elements){ [] }
      lambda { app.line(30) }.should raise_error(ArgumentError)
    end
  end

  describe "oval" do
    specify "creates a Shoes::Oval" do
      app_gui.should_receive(:add_paint_listener)
      app.stub(:unslotted_elements){ [] }
      app.oval(30, 20, 100, 200).should be_an_instance_of(Shoes::Oval)
    end

    specify "raises an ArgumentError" do
      app.stub(:unslotted_elements){ [] }
      lambda { app.oval(10) }.should raise_error(ArgumentError)
    end
  end

  describe "star" do
    specify "creates a Shoes::Star" do
      app_gui.should_receive(:add_paint_listener)
      app.stub(:unslotted_elements){ [] }
      app.star(30, 20).should be_an_instance_of(Shoes::Star)
    end

    specify "raises an ArgumentError" do
      app.stub(:unslotted_elements){ [] }
      lambda { app.star(30) }.should raise_error(ArgumentError)
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
