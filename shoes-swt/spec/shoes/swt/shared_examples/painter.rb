# Provide `shape` (a double) and `subject` (a Painter)

shared_context "painter context" do
  let(:event) { double("event", :gc => gc) }
  let(:gc) { double("gc", :get_line_width => sw).as_null_object }
  let(:fill) { Shoes::Swt::Color.new(Shoes::Color.new(11, 12, 13, fill_alpha)) }
  let(:stroke) { Shoes::Swt::Color.new(Shoes::Color.new(111, 112, 113, stroke_alpha)) }
  let(:fill_alpha) { 70 }
  let(:stroke_alpha) { 110 }
  let(:sw) { 10 }

  before :each do
    allow(shape).to receive(:fill) { fill }
    allow(shape).to receive(:fill_alpha) { fill_alpha }
    allow(shape).to receive(:stroke) { stroke }
    allow(shape).to receive(:stroke_alpha) { stroke_alpha }
    allow(subject).to receive(:reset_rotate) { double("reset_rotate").as_null_object }
  end
end


shared_examples_for "movable painter" do
  describe "when moved" do
    let(:transform) { double("transform").as_null_object }

    before :each do
      allow(::Swt::Transform).to receive(:new) { transform }
      shape.update_position
    end

    it "applies transform" do
      expect(gc).to receive(:set_transform).with(transform)
      subject.paint_control(event)
    end
  end
end

shared_examples_for "stroke painter" do
  describe "sets stroke" do
    specify "color" do
      expect(gc).to receive(:set_foreground).with(stroke.real)
      subject.paint_control(event)
    end

    specify "alpha" do
      allow(gc).to receive(:set_alpha)
      expect(gc).to receive(:set_alpha).with(stroke_alpha)
      subject.paint_control(event)
    end
  end

  it "sets strokewidth" do
    allow(shape).to receive(:strokewidth) { 4 }
    expect(gc).to receive(:set_line_width).with(4)
    subject.paint_control(event)
  end

  it "sets antialias" do
    expect(gc).to receive(:set_antialias).with(Swt::SWT::ON)
    subject.paint_control(event)
  end

  it "sets line cap" do
    expect(gc).to receive(:set_line_cap).with(anything)
    subject.paint_control(event)
  end
end

shared_examples_for "fill painter" do
  describe "sets fill" do
    specify "color" do
      expect(gc).to receive(:set_background).with(fill.real)
      subject.paint_control(event)
    end

    specify "alpha" do
      # Once for stroke, once for fill
      allow(gc).to receive(:set_alpha)
      expect(gc).to receive(:set_alpha).with(fill_alpha)
      subject.paint_control(event)
    end
  end
end
