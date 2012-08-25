shared_examples_for "paintable" do
  it "registers for painting" do
    # Transitioning from gui_container_real to app_real
    container = defined?(gui_container_real) ? gui_container_real : defined?(app_real) ? app_real : app
    container.should_receive(:add_paint_listener)
    subject
  end
end

