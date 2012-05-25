# Requires gui_element
shared_examples_for "movable object with disposable gui element" do
  before :each do
    Swt::Widgets::Composite.stub(:new) { double("composite").as_null_object }
  end

  it "disposes its gui element" do
    pending "setup is WAAAY too complicated"
    gui_element.should_receive(:disposed?)
    gui_element.should_receive(:dispose)
    subject.move(300, 200)
  end
end
