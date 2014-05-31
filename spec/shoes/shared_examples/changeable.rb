shared_examples "an element that can respond to change" do
  describe "when passing a block to the constructor" do
    it "should notify the block of change events" do
      expect(input_block).to receive(:call).with(subject)
      subject.call_change_listeners
    end
  end

  describe "when setting up a callback with #change" do
    it "should notify the callback of change events" do
      called = false
      subject.change do |element|
        called = true
      end
      subject.call_change_listeners
      expect(called).to be_truthy
    end

    it "should pass the element itself to the callback" do
      subject.change do |element|
        expect(element).to eq(subject)
      end
      subject.call_change_listeners
    end
  end
end
