# provide gui_container, subject, stroke, fill
def trigger
  # Accommodates "legacy" specs. Should be phased out.
  if [Shoes::Line].include? subject.class
    subject.gui_paint_callback.call(event)
  elsif subject.class.ancestors.include?(Shoes::Swt::Common::Painter)
    subject.paint_control(event)
  else
    subject.paint_callback.call(event)
  end
end

shared_examples_for "swt stroke" do
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

shared_examples_for "swt fill" do
  it "sets fill color" do
    fill = Shoes::COLORS[:chartreuse].to_native
    shape.stub(:fill) { fill }
    gc.should_receive(:set_background).with(fill)
    subject.paint_control(event)
  end
end

shared_examples_for "Swt object with stroke" do
  let(:stroke) { Shoes::COLORS[:honeydew] }
  let(:strokewidth) { 3 }

  describe "paint callback" do
    include_context "paintable context"

    before :each do
      gui_container_real.should_receive(:add_paint_listener)
      dsl.stub(:stroke) { stroke }
      dsl.stub(:strokewidth) { strokewidth }
    end

    specify "sets stroke color" do
      gc.should_receive(:set_foreground).with(stroke.to_native)
      trigger
    end

    specify "sets antialias" do
      gc.should_receive(:set_antialias).with(Swt::SWT::ON)
      trigger
    end

    specify "sets strokewidth" do
      gc.should_receive(:set_line_width).with(strokewidth)
      trigger
    end
  end
end

shared_examples_for "Swt object with fill" do
  let(:fill) { Shoes::COLORS[:papayawhip] }

  describe "paint callback" do
    let(:event) { double("event") }
    let(:gc) { double("gc").as_null_object }

    before :each do
      event.stub(:gc) { gc }
      gui_container_real.should_receive(:add_paint_listener)
      dsl.stub(:fill) { fill }
    end

    specify "sets fill color" do
      gc.should_receive(:set_background).with(fill.to_native)
      trigger
    end
  end
end
