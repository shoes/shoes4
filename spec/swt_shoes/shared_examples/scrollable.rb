shared_examples_for "scrollable" do
  it "should have a vertical scroll bar" do
    subject.get_vertical_bar.should == Swt::Widgets::ScrollBar
  end
end
