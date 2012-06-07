# provide gui_container, subject, stroke, fill
def trigger
  # Accommodates "legacy" specs. Should be phased out.
  if [Shoes::Line].include? subject.class
    subject.gui_paint_callback.call(event)
  else
    subject.paint_callback.call(event)
  end
end

shared_examples_for "Swt object with stroke" do
  let(:stroke) { Shoes::COLORS[:honeydew] }
  let(:strokewidth) { 3 }

  describe "paint callback" do
    # These should probably be moved out of the shared context
    # in the event that they also need to be used there. See
    # duplication in swt_shoes/oval_spec.rb
    let(:event) { double("event") }
    let(:gc) { double("gc").as_null_object }

    before :each do
      event.stub(:gc) { gc }
      gui_container.should_receive(:add_paint_listener)
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
      gui_container.should_receive(:add_paint_listener)
      dsl.stub(:fill) { fill }
    end

    specify "sets fill color" do
      gc.should_receive(:set_background).with(fill.to_native)
      trigger
    end
  end
end
