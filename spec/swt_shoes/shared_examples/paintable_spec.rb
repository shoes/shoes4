shared_examples_for "paintable" do
  it "registers for painting" do
    # Transitioning from gui_container_real to app_real
    if defined? paint_container
      container = paint_container
    elsif defined? gui_container_real
      container = gui_container_real
    else
      container = app
    end
    container.should_receive(:add_paint_listener)
    subject
  end
end

