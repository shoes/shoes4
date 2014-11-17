shared_examples_for "scrollable slot" do
  its(:scroll) { should be_truthy }
  it "initializes scroll_top to 0" do
    expect(subject.scroll_top).to eq(0)
  end
end

shared_examples_for "scrollable slot with overflowing content" do
  it "retains the same height" do
    expect(subject.height).to eq(height)
  end

  it "has scroll_height larger than height" do
    expect(subject.scroll_height).to be > height
  end

  it "has scroll_max = (scroll_height - height)" do
    expect(subject.scroll_max).to eq(subject.scroll_height - subject.height)
  end

  it 'adjusts scroll_top' do
    expect(subject.scroll_top).to eq(new_position)
  end
end

shared_context "scroll" do
  let(:height) { 200 }
  let(:input_opts) { {left: 40, top: 20, width: 400, height: height} }
  let(:opts) { input_opts.merge(scroll: scroll) }
end

shared_context "overflowing content" do
  let(:new_position) { 300 }

  before :each do
    200.times do
      Shoes::TextBlock.new(app, subject, "Fourteen fat chimichangas", size: 18)
    end
    subject.scroll_top = new_position
  end
end
