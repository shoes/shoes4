shared_examples_for "basic star" do
  it "retains app" do
    subject.app.should eq(app)
  end

  it "creates gui object" do
    subject.gui.should_not be_nil
  end
end

describe Shoes::Star do
  let(:app) { Shoes::App.new }
  subject { Shoes::Star.new(app, 44, 66, 5, 50.0, 30.0) }

  it_behaves_like "basic star"
  it_behaves_like "object with fill"
  it_behaves_like "object with stroke"
  it_behaves_like "movable object"
end
