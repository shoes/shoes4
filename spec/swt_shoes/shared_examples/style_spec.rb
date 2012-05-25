shared_examples_for "Swt object with stroke" do
  describe "paint callback" do
    let(:event) { double("event") }
    let(:gc) { double("gc").as_null_object }

    before :each do
      event.stub(:gc) { gc }
      gui_container.should_receive(:add_paint_listener)
    end

    specify "sets stroke color" do
      gc.should_receive(:set_foreground).with(subject.stroke.to_native)
      subject.gui_paint_callback.call(event)
    end

    specify "sets antialias" do
      gc.should_receive(:set_antialias).with(Swt::SWT::ON)
      subject.gui_paint_callback.call(event)
    end

    specify "sets strokewidth" do
      gc.should_receive(:set_line_width).with(subject.style[:strokewidth])
      subject.gui_paint_callback.call(event)
    end
  end
end

shared_examples_for "Swt object with fill" do
  describe "paint callback" do
    let(:event) { double("event") }
    let(:gc) { double("gc").as_null_object }

    before :each do
      event.stub(:gc) { gc }
      gui_container.should_receive(:add_paint_listener)
    end

    specify "sets fill color" do
      gc.should_receive(:set_background).with(subject.fill.to_native)
      subject.gui_paint_callback.call(event)
    end
  end
end
