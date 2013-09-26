shared_examples_for "basic rect" do
  it "retains app" do
    subject.app.should eq(app)
  end

  it "creates gui object" do
    subject.gui.should_not be_nil
  end
end

describe Shoes::Rect do
  let(:app) { Shoes::App.new }
  subject { Shoes::Rect.new(app, 44, 66, 111, 333) }

  it_behaves_like "basic rect"
  it_behaves_like "object with fill"
  it_behaves_like "object with stroke"
  it_behaves_like "object with style"
  it_behaves_like "movable object"

  context "center" do
    subject { Shoes::Rect.new(app, 100, 50, 40, 20, :center => true) }

    its(:left) { should eq(80) }
    its(:top) { should eq(40) }
    its(:right) { should eq(120) }
    its(:bottom) { should eq(60) }
    its(:width) { should eq(40) }
    its(:height) { should eq(20) }
  end

end
