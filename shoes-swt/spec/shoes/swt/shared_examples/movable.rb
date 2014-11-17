shared_examples "movable element" do |left, top|

  before :each do
    allow(dsl).to receive_messages element_left: left, element_top: top
  end

  context "with disposed real element" do
    before :each do
      allow(real).to receive(:disposed?) { true }
    end

    it "doesn't delegate to real" do
      expect(real).not_to receive(:set_location)
      subject.update_position
    end
  end

  context "with undisposed real element" do
    before :each do
      allow(real).to receive(:disposed?) { false }
    end

    it "delegates to real" do
      expect(real).to receive(:set_location).with(left, top)
      subject.update_position
    end
  end
end

shared_examples_for "movable shape" do |x, y|
  it "redraws container" do
    expect(container).to receive(:redraw).at_least(2).times
    allow(dsl).to receive_messages element_left: x, element_top: y
    subject.update_position
  end
end
