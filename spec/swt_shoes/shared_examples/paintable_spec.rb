shared_examples_for "paintable" do
  it "registers for painting" do
    # Transitioning from gui_container_real to app_real
    container = defined?(gui_container_real) ? gui_container_real : app_real
    container.should_receive(:add_paint_listener)
    subject
  end
end

shared_context "paintable context" do
  let(:event) { double("event") }
  let(:gc) { double("gc").as_null_object }

  before :each do
    event.stub(:gc) { gc }
  end
end

