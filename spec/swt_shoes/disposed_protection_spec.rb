class Harness
  include Shoes::Swt::DisposedProtection

  def initialize(real)
    @real = real
  end
end

describe Shoes::Swt::DisposedProtection do
  let(:width) { 234 }
  let(:real_with_disposed_protection) { Harness.new(bare_real).real }

  context "when real object is NOT disposed" do
    let(:bare_real) { double("delegation object", width: width, dispose: nil, disposed?: false) }

    it "delegates method" do
      real_with_disposed_protection.width
      expect(bare_real).to have_received(:width)
    end

    it "returns the same result as the bare real object" do
      expect(real_with_disposed_protection.width).to eq(width)
    end

    it "disposes real object" do
      real_with_disposed_protection.dispose
      expect(bare_real).to have_received(:dispose)
    end
  end

  context "when real object IS disposed" do
    let(:bare_real) { double("delegation object", width: width, dispose: nil, disposed?: true) }

    it "does NOT delegate method" do
      real_with_disposed_protection.width
      expect(bare_real).not_to have_received(:width)
    end

    it "returns nil" do
      expect(real_with_disposed_protection.width).to eq(nil)
    end

    it "does NOT dispose real object" do
      real_with_disposed_protection.dispose
      expect(bare_real).not_to have_received(:dispose)
    end
  end
end

