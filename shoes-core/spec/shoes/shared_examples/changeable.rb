# frozen_string_literal: true

shared_examples "an element that can respond to change" do
  describe "when passing a block to the constructor" do
    it "should notify the block of change events" do
      expect(input_block).to receive(:call).with(subject)
      subject.call_change_listeners
    end
  end

  describe "when setting up a callback with #change" do
    it "returns the element, not the block" do
      returned = subject.change do
      end

      expect(returned).to eq(subject)
    end

    it "should notify the callback of change events" do
      called = false
      subject.change do
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

  describe "failure handling" do
    include_context "quiet logging"

    it "allows for safe failure in callback" do
      Shoes.configuration.fail_fast = false
      subject.change do
        raise "heck"
      end

      subject.call_change_listeners
    end

    it "fails in callback if configured" do
      Shoes.configuration.fail_fast = true
      subject.change do
        raise "heck"
      end

      expect { subject.call_change_listeners }.to raise_error(RuntimeError)
    end
  end
end
