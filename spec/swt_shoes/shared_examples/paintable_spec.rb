shared_examples_for "paintable" do
  it "registers for painting" do
    swt_app.should_receive(:add_paint_listener)
    subject
  end
end

