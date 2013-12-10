shared_examples_for "paintable" do
  it "registers for painting" do
    # Transitioning from gui_container_real to app_real
    begin
      container = paint_container
    rescue
      begin
        container = gui_container_real
      rescue
        begin
          container = swt_app
        rescue
          container = app
        end
      end
    end
    container.should_receive(:add_paint_listener)
    subject
  end
end

