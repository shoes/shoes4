shared_examples_for "basic border" do
  it "retains app" do
    subject.app.should eq(app)
  end

  it "creates gui object" do
    subject.gui.should_not be_nil
  end
end

describe Shoes::Rect do
  let(:parent) { double("parent") }
  let(:blue)  { Shoes::COLORS[:blue] }
  let(:app_gui) { double("app_gui") }
  let(:app) { double("app", :gui => app_gui) }
  let(:opts){ {app: app} }
  subject { Shoes::Border.new(parent, blue, opts) }

  it_behaves_like "basic border"
end
