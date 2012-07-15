# Requires `real`
shared_examples_for "movable object with disposable real element" do
  let(:parent_real) { double('parent real') }

  before :each do
    parent.stub(:real) { parent_real }
    ::Swt::Widgets::Composite.stub(:new) { double("composite").as_null_object }
  end

  context "parent has layout" do
    let(:app) { double('app').as_null_object }

    before :each do
      real.should_receive(:disposed?) { false }
      parent_real.should_receive(:get_layout) { true }
      parent_real.should_receive(:layout)
      parent.stub(:app) { app }
    end

    it "disposes real element" do
      real.should_receive(:dispose)
      subject.move(300, 200)
    end
  end

  context "parent doesn't have layout" do
    before :each do
      real.should_receive(:disposed?) { false }
      parent_real.should_receive(:get_layout) { false }
    end

    it "doesn't dispose real element" do
      real.should_not_receive(:dispose)
      subject.move(300, 200)
    end
  end
end
