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
end
