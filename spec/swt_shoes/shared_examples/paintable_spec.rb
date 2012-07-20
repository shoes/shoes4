shared_examples_for "paintable" do
  it "registers for painting" do
    gui_container_real.should_receive(:add_paint_listener) do |callback|
      callback.should be_lambda
    end
    subject
  end
end

