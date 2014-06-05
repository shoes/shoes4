shared_examples_for "movable object" do
  it "moves" do
    subject.instance_variable_set(:@app, app)
    expect(subject.move(300, 200)).to eq(subject)
    expect(subject.left).to eq(300)
    expect(subject.top).to eq(200)
  end

  describe "displacing" do
    it "displaces backend object" do
      expect(subject.gui).to receive(:update_position)
      subject.displace(300, 200)
    end

    it "does not change reported values of #left and #top" do
      # no error from calling set location with nil values due to unset values
      allow(subject.gui).to receive :update_position
      original_left = subject.left
      original_top = subject.top
      subject.displace(300, 200)
      expect(subject.left).to eq(original_left)
      expect(subject.top).to eq(original_top)
    end
  end
end

shared_examples_for "left, top as center" do | *params |
  let(:centered_object) { described_class.new(app, parent, left, top, width, height, *params, :center => true) }
  it "should now be located somewhere" do
    expect(centered_object.left).to eq(left-(width/2))
    expect(centered_object.top).to eq(top-(height/2))
    expect(centered_object.width).to eq(width)
    expect(centered_object.height).to eq(height)
  end
end
