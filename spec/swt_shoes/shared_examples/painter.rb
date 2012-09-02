# Provide `shape` (a double) and `subject` (a Painter)

shared_context "painter context" do
  let(:event) { double("event", :gc => gc) }
  let(:gc) { double("gc").as_null_object }
  let(:shape) { double("shape").as_null_object }

  before :each do
    shape.stub(:left) { left }
    shape.stub(:top) { top }
    shape.stub(:width) { width }
    shape.stub(:height) { height }
  end
end

shared_examples_for "movable painter" do
  describe "when moved" do
    let(:transform) { double("transform").as_null_object }

    before :each do
      ::Swt::Transform.stub(:new) { transform }
      shape.move(20, 30)
    end

    it "applies transform" do
      gc.should_receive(:set_transform).with(transform)
      subject.paint_control(event)
    end
  end
end

shared_examples_for "stroke painter" do
  it "sets stroke color" do
    stroke = Shoes::COLORS[:honeydew].to_native
    shape.stub(:stroke) { stroke }
    gc.should_receive(:set_foreground).with(stroke)
    subject.paint_control(event)
  end

  it "sets strokewidth" do
    shape.stub(:strokewidth) { 4 }
    gc.should_receive(:set_line_width).with(4)
    subject.paint_control(event)
  end

  it "sets antialias" do
    gc.should_receive(:set_antialias).with(Swt::SWT::ON)
    subject.paint_control(event)
  end
end

shared_examples_for "fill painter" do
  it "sets fill color" do
    fill = Shoes::COLORS[:chartreuse].to_native
    shape.stub(:fill) { fill }
    gc.should_receive(:set_background).with(fill)
    subject.paint_control(event)
  end
end
