# Provide `shape` (a double) and `subject` (a Painter)

shared_context "painter context" do
  let(:event) { double("event", :gc => gc) }
  let(:gc) { double("gc").as_null_object }
  let(:fill) { Shoes::COLORS[:chartreuse].to_native }
  let(:stroke) { Shoes::COLORS[:papayawhip].to_native }
  let(:fill_alpha) { 70 }
  let(:stroke_alpha) { 110 }

  before :each do
    shape.stub(:fill) { fill }
    shape.stub(:fill_alpha) { fill_alpha }
    shape.stub(:stroke) { stroke }
    shape.stub(:stroke_alpha) { stroke_alpha }
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
  describe "sets stroke" do
    specify "color" do
      gc.should_receive(:set_foreground).with(stroke)
      subject.paint_control(event)
    end

    specify "alpha" do
      gc.stub(:set_alpha)
      gc.should_receive(:set_alpha).with(stroke_alpha)
      subject.paint_control(event)
    end
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
  describe "sets fill" do
    specify "color" do
      gc.should_receive(:set_background).with(fill)
      subject.paint_control(event)
    end

    specify "alpha" do
      # Once for stroke, once for fill
      gc.stub(:set_alpha)
      gc.should_receive(:set_alpha).with(fill_alpha)
      subject.paint_control(event)
    end
  end
end
