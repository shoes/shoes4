describe Shoes::Swt::WithDisposedProtection do
  let(:width) { 234 }
  subject(:delegator) { Shoes::Swt::WithDisposedProtection.new delegation_object }

  context "when delegation object is NOT disposed" do
    let(:delegation_object) { double("delegation object", width: width, dispose: nil, disposed?: false) }

    it "delegates method" do
      delegator.width
      expect(delegation_object).to have_received(:width)
    end

    it "returns the same result as the delegation object" do
      expect(delegator.width).to eq(width)
    end

    it "disposes delegation object" do
      delegator.dispose
      expect(delegation_object).to have_received(:dispose)
    end
  end

  context "when delegation object IS disposed" do
    let(:delegation_object) { double("delegation object", width: width, dispose: nil, disposed?: true) }

    it "does NOT delegate method" do
      delegator.width
      expect(delegation_object).not_to have_received(:width)
    end

    it "returns nil" do
      expect(delegator.width).to eq(nil)
    end

    it "does NOT dispose delegation object" do
      delegator.dispose
      expect(delegation_object).not_to have_received(:dispose)
    end
  end
end

