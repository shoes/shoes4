shared_examples_for "paintable" do
  it "registers for painting" do
    # Transitioning from gui_container_real to app_real
    container = defined?(gui_container_real) ? gui_container_real : app_real
    container.should_receive(:add_paint_listener)
    subject
  end
end

shared_context "minimal painter context" do
  before :each do
    shape.stub(:left) { left }
    shape.stub(:top) { top }
    shape.stub(:width) { width }
    shape.stub(:height) { height }
  end
end

shared_context "painter context" do
  include_context "paintable context"

  before :each do
    shape.should_receive(:fill)
    shape.should_receive(:fill_alpha)
    shape.should_receive(:stroke)
    shape.should_receive(:stroke_alpha)
    shape.should_receive(:strokewidth) { 5 }
    shape.should_receive(:left).twice { left }
    shape.should_receive(:top).twice { top }
    shape.should_receive(:width).at_least(2).times { width }
    shape.should_receive(:height).at_least(2).times { height}
  end
end

shared_context "paintable context" do
  let(:event) { double("event", :gc => gc) }
  let(:gc) { double("gc").as_null_object }
end

